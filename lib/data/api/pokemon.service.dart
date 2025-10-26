import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_evolution_chain.model.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';

import '../models/pokemon_form.model.dart';

class PokemonService {
  PokemonService._privateConstructor();
  static final PokemonService instance = PokemonService._privateConstructor();

  final String baseUrl = 'https://pokeapi.co/api/v2';
  final http.Client client = http.Client();

  Box<String>? _cacheBox;
  Future<void> _initCacheBox() async {
    _cacheBox ??= await Hive.openBox<String>('pokemon_cache');
  }

  Future<Map<String, dynamic>> getDataCached(String key, String url) async {
    await _initCacheBox();

    final cachedData = _cacheBox!.get(key);
    if (cachedData != null) {
      return jsonDecode(cachedData);
    }

    final response = await client.get(
      Uri.parse(url),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load data from $url');
    }

    _cacheBox!.put(key, response.body);
    return jsonDecode(response.body);
  }

  Future<PokemonSpecies> fetchSpeciesAndDefaultVariant(int id) async {
    final speciesJson = await getDataCached('pokemon_species_$id', '$baseUrl/pokemon-species/$id');
    final species = PokemonSpecies.fromJson(speciesJson);

    final defaultVariant = speciesJson['varieties']
        .firstWhere((v) => v['is_default'] == true);
    final variantUrl = defaultVariant['pokemon']['url'];

    final pokemonJson = await getDataCached('pokemon_$id', variantUrl);
    final pokemon = Pokemon.fromJson(pokemonJson, species);

    await fetchAllFormsForPokemon(pokemon);

    if (!species.variants.any((v) => v.id == pokemon.id)) {
      species.variants.add(pokemon);
    }
    return species;
  }

  Future<List<PokemonSpecies>> fetchAllPokemonSpecies({int offset=0, int limit=20}) async {
    final response = await client.get(
      Uri.parse('$baseUrl/pokemon-species?offset=$offset&limit=$limit'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokémon species list');
    }
    
    final data = jsonDecode(response.body);
    final results = data['results'] as List<dynamic>;

    final futures = results.map((speciesInfo) async {
      final speciesUrl = speciesInfo['url'];
      final speciesId = int.parse(speciesUrl.split('/')[6]);
      final species = await fetchSpeciesAndDefaultVariant(speciesId);
      return species;
    }).toList();

    final speciesList = await Future.wait(futures);
    return speciesList;
  }

  Future<PokemonForm> fetchDefaultFormForPokemon(Pokemon pokemon) async {
    final pokemonJson = await getDataCached('pokemon_${pokemon.id}', '$baseUrl/pokemon/${pokemon.id}');
    final formsData = pokemonJson['forms'] as List<dynamic>;
    if (formsData.isEmpty) {
      throw Exception('No forms found for Pokémon ID: ${pokemon.id}');
    }
    final defaultFormData = formsData[0];
    final formUrl = defaultFormData['url'];
    final formId = int.parse(formUrl.split('/')[6]);
    if (pokemon.forms.any((form) => form.id == formId)) {
      return pokemon.forms.firstWhere((form) => form.id == formId);
    }
    final formJson = await getDataCached('pokemon_form_$formId', formUrl);
    final defaultForm = PokemonForm.fromJson(formJson, pokemon);
    pokemon.forms.add(defaultForm);
    return defaultForm;
  }

  Future<List<PokemonForm>> fetchAllFormsForPokemon(Pokemon pokemon) async {
    final pokemonJson = await getDataCached('pokemon_${pokemon.id}', '$baseUrl/pokemon/${pokemon.id}');
    final formsData = pokemonJson['forms'] as List<dynamic>;
    if (formsData.isEmpty) {
      throw Exception('No forms found for Pokémon ID: ${pokemon.id}');
    }

    final List<PokemonForm> forms = [];

    if (pokemon.forms.isEmpty) {
      final defaultFormData = formsData[0];
      final formUrl = defaultFormData['url'];
      final formId = int.parse(formUrl.split('/')[6]);
      final formJson = await getDataCached('pokemon_form_$formId', formUrl);
      final defaultForm = PokemonForm.fromJson(formJson, pokemon);
      forms.add(defaultForm);
      pokemon.forms.add(defaultForm);
    } else {
      forms.add(pokemon.defaultForm);
    }

    for (int i = 1; i < formsData.length; i++) {
      final formData = formsData[i];
      final formUrl = formData['url'];
      final formId = int.parse(formUrl.split('/')[6]);
      if (pokemon.forms.any((form) => form.id == formId)) {
        forms.add(pokemon.forms.firstWhere((form) => form.id == formId));
        continue;
      }
      final formJson = await getDataCached('pokemon_form_$formId', formUrl);
      final form = PokemonForm.fromJson(formJson, pokemon, defaultForm: pokemon.defaultForm);
      forms.add(form);
      pokemon.forms.add(form);
    }
    return forms;
  }

  Future<List<Pokemon>> fetchAllVariantsForSpecies(PokemonSpecies species) async {
    final speciesJson = await getDataCached('pokemon_species_${species.id}', '$baseUrl/pokemon-species/${species.id}');
    final varieties = speciesJson['varieties'] as List<dynamic>;
    final List<Pokemon> variants = [];

    for (var variety in varieties) {
      final variantUrl = variety['pokemon']['url'];
      final variantId = int.parse(variantUrl.split('/')[6]);
      if (species.variants.any((v) => v.id == variantId)) {
        variants.add(species.variants.firstWhere((v) => v.id == variantId));
        continue;
      }
      final pokemonJson = await getDataCached('pokemon_$variantId', variantUrl);
      final pokemon = Pokemon.fromJson(pokemonJson, species);
      try {
        await fetchAllFormsForPokemon(pokemon);
      } catch (e) {
        print('Error fetching forms for Pokémon ID: ${pokemon.id}, Error: $e');
        continue;
      }
      species.variants.add(pokemon);
      variants.add(pokemon);
    }
    return variants;
  }

  Future<List<PokemonSpecies>> fetchEvolutionsForSpecies(PokemonSpecies species) async {
    final speciesJson = await getDataCached('pokemon_species_${species.id}', '$baseUrl/pokemon-species/${species.id}');
    final evolutionChainUrl = speciesJson['evolution_chain']['url'];
    final evolutionChainId = int.parse(evolutionChainUrl.split('/')[6]);
    final evolutionChainJson = await getDataCached('evolution_chain_$evolutionChainId', evolutionChainUrl);
    final chain = PokemonEvolutionChain.fromJson(evolutionChainJson);
    final evolutions = chain.getSpeciesEvolution('$baseUrl/pokemon-species/${species.id}/');
    final List<PokemonSpecies> evolutionSpeciesList = [];
    for (var evolutionUrl in evolutions) {
      final evolutionId = int.parse(evolutionUrl.split('/')[6]);
      if (species.evolutions.any((v) => v.id == evolutionId)) {
        evolutionSpeciesList.add(species.evolutions.firstWhere((v) => v.id == evolutionId));
        continue;
      }
      final evolutionSpeciesJson = await getDataCached('pokemon_species_$evolutionId', evolutionUrl);
      final evolutionSpecies = PokemonSpecies.fromJson(evolutionSpeciesJson);
      await fetchAllVariantsForSpecies(evolutionSpecies);
      species.evolutions.add(evolutionSpecies);
      evolutionSpeciesList.add(evolutionSpecies);
    }
    return evolutionSpeciesList;
  }

  Future<PokemonSpecies?> fetchPreEvolutionForSpecies(PokemonSpecies species) async {
    final speciesJson = await getDataCached('pokemon_species_${species.id}', '$baseUrl/pokemon-species/${species.id}');

    final preEvolutionUrl = speciesJson['evolves_from_species'] != null
        ? speciesJson['evolves_from_species']['url']
        : null;
    if (preEvolutionUrl != null) {
      final preEvolutionId = int.parse(preEvolutionUrl.split('/')[6]);
      if (species.preEvolution != null && species.preEvolution!.id == preEvolutionId) {
        return species.preEvolution;
      }
      final preEvolutionSpeciesJson = await getDataCached('pokemon_species_$preEvolutionId', preEvolutionUrl);
      final preEvolutionSpecies = PokemonSpecies.fromJson(preEvolutionSpeciesJson);
      await fetchAllVariantsForSpecies(preEvolutionSpecies);
      species.preEvolution = preEvolutionSpecies;
      return preEvolutionSpecies;
    } else {
      species.preEvolution = null;
      return null;
    }
  }
}
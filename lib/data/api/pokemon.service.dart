import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon_form.model.dart';

class PokemonService {
  PokemonService._privateConstructor();
  static final PokemonService instance = PokemonService._privateConstructor();

  final String baseUrl = 'https://pokeapi.co/api/v2';
  final http.Client client = http.Client();

  Future<Map<String, dynamic>> getDataCached(String key, String url) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(key);
    Map<String, dynamic> json;

    if (cachedData != null) {
      json = jsonDecode(cachedData);
    } else {
      final response = await client.get(
        Uri.parse(url),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load data from $url');
      }

      json = jsonDecode(response.body);
      await prefs.setString(key, response.body);
    }
    return json;
  }

  Future<PokemonSpecies> fetchSpeciesAndDefaultVariant(int id) async {
    final speciesJson = await getDataCached('pokemon_species_$id', '$baseUrl/pokemon-species/$id');
    final species = PokemonSpecies.fromJson(speciesJson);

    final defaultVariant = speciesJson['varieties']
        .firstWhere((v) => v['is_default'] == true);
    final variantUrl = defaultVariant['pokemon']['url'];

    final pokemonJson = await getDataCached('pokemon_$id', variantUrl);
    final pokemon = Pokemon.fromJson(pokemonJson, species);

    final defaultForm = pokemonJson['forms'][0];
    final formUrl = defaultForm['url'];
    final formId = int.parse(formUrl.split('/')[6]);

    final formJson = await getDataCached('pokemon_form_$formId', formUrl);
    final form = PokemonForm.fromJson(formJson, pokemon);

    pokemon.forms.add(form);
    species.variants.add(pokemon);

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
      return await fetchSpeciesAndDefaultVariant(speciesId);
    }).toList();

    final speciesList = await Future.wait(futures);
    return speciesList;
  }

  Future<void> fetchAllFormsForPokemon(Pokemon pokemon) async {

    final pokemonJson = await getDataCached('pokemon_${pokemon.id}', '$baseUrl/pokemon/${pokemon.id}');

    final formsData = pokemonJson['forms'] as List<dynamic>;

    pokemon.forms.clear();

    final defaultFormData = formsData[0];
    final formUrl = defaultFormData['url'];
    final formId = int.parse(formUrl.split('/')[6]);
    final formJson = await getDataCached('pokemon_form_$formId', formUrl);
    final defaultForm = PokemonForm.fromJson(formJson, pokemon);
    pokemon.forms.add(defaultForm);


    for (int i = 1; i < formsData.length; i++) {
      final formData = formsData[i];
      final formUrl = formData['url'];
      final formId = int.parse(formUrl.split('/')[6]);
      final formJson = await getDataCached('pokemon_form_$formId', formUrl);
      final form = PokemonForm.fromJson(formJson, pokemon, defaultForm: defaultForm);
      pokemon.forms.add(form);
    }
  }
}
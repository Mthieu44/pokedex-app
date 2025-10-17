import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon_form.model.dart';

class PokemonService {
  final String baseUrl = 'https://pokeapi.co/api/v2';
  final http.Client client = http.Client();

  Future<List<PokemonSpecies>> fetchAllPokemonSpecies({int offset=0, int limit=20}) async {
    final response = await client.get(
      Uri.parse('$baseUrl/pokemon-species?offset=$offset&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<PokemonSpecies> speciesList = [];
      final prefs = await SharedPreferences.getInstance();

      for (var item in data['results']) {
        final speciesUrl = item['url'];
        final id = int.parse(speciesUrl.split('/')[6]);
        try {
          final cachedSpecies = prefs.getString('pokemon_species_$id');
          Map<String, dynamic> speciesJson;
          if (cachedSpecies != null) {
            speciesJson = jsonDecode(cachedSpecies);
          } else {
            final speciesResponse = await client.get(
              Uri.parse(speciesUrl),
            );
            if (speciesResponse.statusCode != 200) {
              print('Failed to load species with id $id');
              continue;
            }
            speciesJson = jsonDecode(speciesResponse.body);
            await prefs.setString('pokemon_species_$id', speciesResponse.body);
          }

          final species = PokemonSpecies.fromJson(speciesJson);

          final defaultVariant = speciesJson['varieties']
              .firstWhere((v) => v['is_default'] == true);

          final variantUrl = defaultVariant['pokemon']['url'];
          final cachedPokemon = prefs.getString('pokemon_${species.id}');
          Map<String, dynamic> pokemonJson;

          if (cachedPokemon != null) {
            pokemonJson = jsonDecode(cachedPokemon);
          } else {
            final pokemonResponse = await client.get(
              Uri.parse(variantUrl),
            );
            if (pokemonResponse.statusCode != 200) {
              print('Failed to load pokemon for species id $id');
              continue;
            }
            pokemonJson = jsonDecode(pokemonResponse.body);
            await prefs.setString('pokemon_${species.id}', pokemonResponse.body);
          }

          final pokemon = Pokemon.fromJson(pokemonJson, species);
          species.variants.add(pokemon);
          speciesList.add(species);
        } catch (e) {
          print('Error fetching species with id $id: $e');
          continue;
        }
      }
      return speciesList;
    } else {
      throw Exception('Failed to load Pokémon species');
    }
  }
}
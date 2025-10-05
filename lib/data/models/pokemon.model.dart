import 'dart:math';

import 'package:pokedex_app/data/models/pokemon_type.model.dart';
import 'package:pokedex_app/data/models/pokemon_stats.model.dart';

class Pokemon {
  const Pokemon({
    required this.id,
    required this.pokedexId,
    required this.name,
    required this.image,
    required this.stats,
    required this.primaryType,
    this.secondaryType,
    required this.apiGeneration,
    this.evolution,
    this.preEvolution,
  });

  final int id;
  final int pokedexId;
  final String name;
  final String image;
  final PokemonStats stats;
  final PokemonType primaryType;
  final PokemonType? secondaryType;
  final int apiGeneration;
  final Pokemon? evolution;
  final Pokemon? preEvolution;

  static Pokemon mock(String type) {
    final random = Random();
    final id = random.nextInt(800);
    final pokedexId = id;
    final name = "Pokemon $pokedexId";
    //final image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokedexId.png";
    final image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokedexId.png";
    final stats = PokemonStats.mock();
    final primaryType = PokemonType.fromString(type);
    final secondaryType = null;
    final apiGeneration = 1;

    return Pokemon(
      id: id,
      pokedexId: pokedexId,
      name: name,
      image: image,
      stats: stats,
      primaryType: primaryType,
      secondaryType: secondaryType,
      apiGeneration: apiGeneration,
    );
  }
}


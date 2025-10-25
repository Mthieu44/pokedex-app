import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';

class PokemonEvolutionChain {
  final int id;
  final List<List<String>> evolutions;

  PokemonEvolutionChain({
    required this.id,
    required this.evolutions,
  });

  List<String> getSpeciesEvolution(String speciesUrl) {
    List<String> evolutionList = [];
    for (var i = 0; i < evolutions.length - 1; i++) {
      if (evolutions[i].contains(speciesUrl)) {
        for (var j = i+1; j < evolutions.length; j++) {
          evolutionList.addAll(evolutions[j]);
        }
        return evolutionList;
      }
    }
    return evolutionList;
  }

  factory PokemonEvolutionChain.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    List<List<String>> evolutions = [];

    void parseEvolutionChain(Map<String, dynamic> chain, int level) {
      if (evolutions.length <= level) {
        evolutions.add([]);
      }

      String speciesUrl = chain['species']['url'];
      evolutions[level].add(speciesUrl);
      for (var evolution in chain['evolves_to']) {
        parseEvolutionChain(evolution, level + 1);
      }
    }

    parseEvolutionChain(json['chain'], 0);

    return PokemonEvolutionChain(
      id: id,
      evolutions: evolutions,
    );
  }
}
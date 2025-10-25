import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';

class PokemonRepository {
  final PokemonService _service = PokemonService.instance;

  Future<List<Pokemon>> getVariants(PokemonSpecies species) async {
    return await _service.fetchAllVariantsForSpecies(species);
  }

  Future<List<PokemonSpecies>> getEvolutions(PokemonSpecies species) async {
    return await _service.fetchEvolutionsForSpecies(species);
  }

  Future<PokemonSpecies?> getPreEvolution(PokemonSpecies species) async {
    return await _service.fetchPreEvolutionForSpecies(species);
  }
}
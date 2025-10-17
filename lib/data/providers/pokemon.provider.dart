import 'package:flutter/material.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';

class PokemonProvider extends ChangeNotifier {
  final PokemonService _pokemonService = PokemonService();
  final List<PokemonSpecies> _pokemonSpecies = [];
  List<PokemonSpecies> get speciesList => _pokemonSpecies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _offset = 0;
  final int _limit = 20;

  Future<void> loadInitial() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final initialSpecies = await _pokemonService.fetchAllPokemonSpecies(
        offset: _offset,
        limit: _limit,
      );
      _pokemonSpecies.addAll(initialSpecies);
      _offset += _limit;
    } catch (e) {
      debugPrint('Error loading initial Pokémon species: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final newSpecies = await _pokemonService.fetchAllPokemonSpecies(
        offset: _offset,
        limit: _limit,
      );
      if (newSpecies.isEmpty) {
        _hasMore = false;
      } else {
        _pokemonSpecies.addAll(newSpecies);
        _offset += _limit;
      }
    } catch (e) {
      debugPrint('Error loading Pokémon species: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
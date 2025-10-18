import 'package:flutter/material.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';

class PokemonProvider extends ChangeNotifier {
  final PokemonService _pokemonService = PokemonService.instance;
  final List<PokemonSpecies> _pokemonSpecies = [];
  List<PokemonSpecies> get speciesList => _pokemonSpecies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool _hasError = false;
  bool get hasError => _hasError;

  int _offset = 0;
  final int _limit = 20;

  Future<void> loadInitial() async {
    if (_isLoading) return;
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final initialSpecies = await _pokemonService.fetchAllPokemonSpecies(
        offset: _offset,
        limit: _limit,
      );
      _pokemonSpecies..clear()..addAll(initialSpecies);
      _offset = _pokemonSpecies.length;
      _hasMore = initialSpecies.length == _limit;
    } catch (e) {
      debugPrint('Error loading initial Pokémon species: $e');
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    notifyListeners();

    try {
      final newSpecies = await _pokemonService.fetchAllPokemonSpecies(
        offset: _offset,
        limit: _limit,
      );
      if (newSpecies.isNotEmpty) {
        _pokemonSpecies.addAll(newSpecies);
        _offset += newSpecies.length;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('Error loading more Pokémon species: $e');
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _pokemonSpecies.clear();
    _isLoading = false;
    _hasMore = true;
    _hasError = false;
    _offset = 0;
    notifyListeners();
  }
}
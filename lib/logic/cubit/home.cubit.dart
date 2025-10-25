import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';

class HomeState {
  final List<PokemonSpecies> speciesList;
  final bool isLoading;
  final bool hasMore;
  final bool hasError;

  HomeState({
    required this.speciesList,
    this.isLoading = false,
    this.hasMore = true,
    this.hasError = false,
  });

  HomeState copyWith({
    List<PokemonSpecies>? speciesList,
    bool? isLoading,
    bool? hasMore,
    bool? hasError,
  }) {
    return HomeState(
      speciesList: speciesList ?? this.speciesList,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      hasError: hasError ?? this.hasError,
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  final _service = PokemonService.instance;
  final int _limit = 20;
  int _offset = 0;

  HomeCubit() : super(HomeState(speciesList: []));

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      final initialSpecies = await _service.fetchAllPokemonSpecies(
        offset: _offset,
        limit: _limit,
      );
      _offset = initialSpecies.length;
      emit(state.copyWith(
        speciesList: initialSpecies,
        hasMore: initialSpecies.length == _limit,
      ));
    } catch (e) {
      emit(state.copyWith(hasError: true));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    emit(state.copyWith(isLoading: true));

    try {
      final newSpecies = await _service.fetchAllPokemonSpecies(
        offset: _offset,
        limit: _limit,
      );
      final updatedList = List<PokemonSpecies>.from(state.speciesList)
        ..addAll(newSpecies);
      _offset += newSpecies.length;
      emit(state.copyWith(
        speciesList: updatedList,
        hasMore: newSpecies.length == _limit,
      ));
    } catch (e) {
      emit(state.copyWith(hasError: true));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> reset() async {
    _offset = 0;
    emit(HomeState(speciesList: []));
    await loadInitial();
  }
}
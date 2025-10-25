import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PokemonListState<T> {
  const PokemonListState();
}

class PokemonListLoading<T> extends PokemonListState<T> {}

class PokemonListLoaded<T> extends PokemonListState<T> {
  final List<T> data;
  const PokemonListLoaded(this.data);
}

class PokemonListError<T> extends PokemonListState<T> {
  final String message;
  const PokemonListError(this.message);
}

class PokemonListEmpty<T> extends PokemonListState<T> {}

class PokemonListCubit<T> extends Cubit<PokemonListState<T>> {
  final Future<List<T>> Function() fetchFunction;

  PokemonListCubit({required this.fetchFunction}) : super(PokemonListLoading());

  Future<void> load() async {
    emit(PokemonListLoading());
    try {
      final data = await fetchFunction();
      if (data.isEmpty) {
        emit(PokemonListEmpty());
      } else {
        emit(PokemonListLoaded(data));
      }
    } catch (e) {
      emit(PokemonListError(e.toString()));
    }
  }
}
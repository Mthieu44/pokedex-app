import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PokemonItemState<T> {
  const PokemonItemState();
}

class PokemonItemLoading<T> extends PokemonItemState<T> {}

class PokemonItemLoaded<T> extends PokemonItemState<T> {
  final T data;
  const PokemonItemLoaded(this.data);
}

class PokemonItemError<T> extends PokemonItemState<T> {
  final String message;
  const PokemonItemError(this.message);
}

class PokemonItemEmpty<T> extends PokemonItemState<T> {}

class PokemonItemCubit<T> extends Cubit<PokemonItemState<T>> {
  final Future<T?> Function() fetchFunction;

  PokemonItemCubit({required this.fetchFunction}) : super(PokemonItemLoading());

  Future<void> load() async {
    emit(PokemonItemLoading());
    try {
      final data = await fetchFunction();
      if (data == null) {
        emit(PokemonItemEmpty());
      } else {
        emit(PokemonItemLoaded(data));
      }
    } catch (e) {
      emit(PokemonItemError(e.toString()));
    }
  }
}
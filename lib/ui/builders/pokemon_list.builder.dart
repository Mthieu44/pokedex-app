import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/logic/cubit/pokemon_list.cubit.dart';
import 'package:pokedex_app/ui/skeletons/circle.skeleton.dart';
import 'package:pokedex_app/ui/skeletons/list.skeleton.dart';
import 'package:pokedex_app/ui/skeletons/pokemon_image.skeleton.dart';
import 'package:pokedex_app/ui/widgets/empty_list.widget.dart';

import '../../logic/cubit/pokemon_item.cubit.dart';

class PokemonAsyncBuilder<T> extends StatelessWidget {
  final Cubit cubit;
  final Widget Function(List<T> data) builder;

  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget Function(String message)? errorBuilder;

  const PokemonAsyncBuilder({
    super.key,
    required this.cubit,
    required this.builder,
    this.loadingWidget,
    this.emptyWidget,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        if (state is PokemonListLoading<T>) {
          return loadingWidget ?? const ListSkeleton(count: 5, skeleton: PokemonImageSkeleton(size: 75));
        }
        else if (state is PokemonItemLoading<T>) {
          return loadingWidget ?? const ListSkeleton(count: 1, skeleton: PokemonImageSkeleton(size: 75));
        }
        else if (state is PokemonListEmpty<T> || state is PokemonItemEmpty<T>) {
          return emptyWidget ?? const EmptyListWidget();
        } else if (state is PokemonListError<T>) {
          return errorBuilder != null
              ? errorBuilder!(state.message)
              : Center(child: Text('Error: ${state.message}'));
        } else if (state is PokemonItemError<T>) {
          return errorBuilder != null
              ? errorBuilder!(state.message)
              : Center(child: Text('Error: ${state.message}'));
        } else if (state is PokemonListLoaded<T>) {
          return builder(state.data);
        } else if (state is PokemonItemLoaded<T>) {
          return builder([state.data]);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/logic/cubit/home.cubit.dart';
import 'package:pokedex_app/ui/skeletons/pokemon_card.skeleton.dart';
import 'package:pokedex_app/ui/widgets/action_menu.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_card.widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin{
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<HomeCubit>();
    if (cubit.state.hasMore &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
          cubit.loadMore();
        }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _getItemCount(HomeState state) {
    if (state.isLoading && state.speciesList.isEmpty) {
      return 20;
    } else if (state.hasMore) {
      return state.speciesList.length + 2;
    } else {
      return state.speciesList.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: ActionMenuWidget(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final speciesList = state.speciesList;

          return RefreshIndicator(
            onRefresh: () async => context.read<HomeCubit>().reset(),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(3.0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _getItemCount(state),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                if (index < speciesList.length) {
                  final species = speciesList[index];
                  return PokemonCard(
                    key: ValueKey(species.id),
                    pokemonSpecies: species
                  );
                }

                return const PokemonCardSkeleton();
              },
            ),
          );
        },
      )
    );
  }
}

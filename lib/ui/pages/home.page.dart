import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/logic/cubit/home.cubit.dart';
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


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: ActionMenuWidget(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading && state.speciesList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else if (state.speciesList.isEmpty) {
            return Center(child: Text("No Pokémon found."));
          }
          if (state.hasError) {
            return Center(
              child: Text("An error occurred while loading Pokémon."),
            );
          }

          final speciesList = state.speciesList;

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<HomeCubit>().reset();
            },
            child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(3),
              physics: AlwaysScrollableScrollPhysics(),
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              addSemanticIndexes: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1.4,
              ),
              itemCount: speciesList.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < speciesList.length) {
                  final species = speciesList[index];
                  return PokemonCard(
                    key: ValueKey(species.id),
                    pokemonSpecies: species
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          );
        },
      )
    );
  }
}

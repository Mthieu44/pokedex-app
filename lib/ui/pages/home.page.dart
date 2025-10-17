import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';
import 'package:pokedex_app/data/providers/pokemon.provider.dart';
import 'package:pokedex_app/ui/modals/types_filter.dialog.dart';
import 'package:pokedex_app/ui/widgets/action_menu.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_card.widget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../data/api/pokemon.service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PokemonProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadInitial();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          !provider.isLoading &&
          provider.hasMore) {
        provider.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ActionMenuWidget(),
      appBar: AppBar(
        title: Text(""),
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.speciesList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.speciesList.isEmpty) {
            return Center(child: Text("No Pokémon found."));
          }

          final speciesList = provider.speciesList;

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadInitial();
            },
            child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(3),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1.4,
              ),
              itemCount: speciesList.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < speciesList.length) {
                  final species = speciesList[index];
                  return PokemonCard(pokemonSpecies: species);
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

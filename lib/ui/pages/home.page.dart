import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/widgets/pokemon_card.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_type_bubble.widget.dart';
import '../../data/models/pokemon.model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 1.4,
          padding: EdgeInsets.all(3),
          children: [
            PokemonCard(pokemon: Pokemon.mock("fire")),
            PokemonCard(pokemon: Pokemon.mock("water")),
            PokemonCard(pokemon: Pokemon.mock("grass")),
            PokemonCard(pokemon: Pokemon.mock("electric")),
            PokemonCard(pokemon: Pokemon.mock("psychic")),
            PokemonCard(pokemon: Pokemon.mock("ice")),
            PokemonCard(pokemon: Pokemon.mock("dragon")),
            PokemonCard(pokemon: Pokemon.mock("fairy")),
            PokemonCard(pokemon: Pokemon.mock("rock")),
            PokemonCard(pokemon: Pokemon.mock("ground")),
            PokemonCard(pokemon: Pokemon.mock("flying")),
            PokemonCard(pokemon: Pokemon.mock("bug")),
            PokemonCard(pokemon: Pokemon.mock("ghost")),
            PokemonCard(pokemon: Pokemon.mock("dark")),
            PokemonCard(pokemon: Pokemon.mock("steel")),
            PokemonCard(pokemon: Pokemon.mock("normal")),
            PokemonCard(pokemon: Pokemon.mock("fighting")),
            PokemonCard(pokemon: Pokemon.mock("poison")),
          ]
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/models/pokemon_type.model.dart';
import 'package:pokedex_app/data/providers/pokemon.provider.dart';
import 'package:pokedex_app/ui/pages/home.page.dart';
import 'package:pokedex_app/ui/pages/pokemon_details.page.dart';
import 'package:provider/provider.dart';

import 'data/models/pokemon.model.dart';



void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokemonProvider()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage()
    );
  }
}
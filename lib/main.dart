import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex_app/logic/cubit/home.cubit.dart';
import 'package:pokedex_app/ui/pages/home.page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => HomeCubit()..loadInitial(),
        child: const MyHomePage()
      )
    );
  }
}

//TODO: ajouter filtres home page
//TODO: ajouter favoris
//TODO: gérer erreurs images manquantes
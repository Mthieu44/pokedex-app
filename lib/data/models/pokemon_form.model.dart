import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_image.model.dart';

class PokemonForm {
  final int id;
  final String name;
  final String formName;
  PokemonImage images;
  final Pokemon parentPokemon;
  
  PokemonForm({
    required this.id,
    required this.name,
    required this.formName,
    this.images = const PokemonImage(sprite2D: '', sprite2DShiny: ''),
    required this.parentPokemon,
  });

  factory PokemonForm.fromJson(Map<String, dynamic> json, Pokemon parentPokemon) {
    int id = json['id'];
    String name;
    String formName = json['form_name'];

    if (json['names'].isNotEmpty) {
      name = json['names']
          .firstWhere((n) => n['language']['name'] == 'en', orElse: () => {"name": parentPokemon.parentSpecies.name})['name'];
    } else {
      name = parentPokemon.parentSpecies.name;
    }

    return PokemonForm(
        id: id,
        name: name,
        formName: formName,
        parentPokemon: parentPokemon
    );
  }
}
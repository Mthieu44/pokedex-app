import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_image.model.dart';

class PokemonForm {
  final int id;
  final String name;
  final String formName;
  final String displayFormName;
  PokemonImage images;
  final Pokemon parentPokemon;
  
  PokemonForm({
    required this.id,
    required this.name,
    required this.formName,
    required this.displayFormName,
    this.images = const PokemonImage(sprite2D: '', sprite2DShiny: ''),
    required this.parentPokemon,
  });

  factory PokemonForm.fromJson(Map<String, dynamic> json, Pokemon parentPokemon, {PokemonForm? defaultForm}) {
    int id = json['id'];
    String name;
    String formName = json['form_name'];
    String displayFormName;
    PokemonImage images;

    if (json['names'].isNotEmpty) {
      name = json['names']
          .firstWhere((n) => n['language']['name'] == 'en', orElse: () => {"name": parentPokemon.parentSpecies.name})['name'];
    } else {
      name = parentPokemon.parentSpecies.name;
    }

    if (json['form_names'].isNotEmpty) {
      displayFormName = json['form_names']
          .firstWhere((n) => n['language']['name'] == 'en', orElse: () => {"name": formName})['name'];
    } else {
      displayFormName = formName;
    }

    if (defaultForm == null) {
      images = parentPokemon.images;
    } else {
      images = PokemonImage.formFromDefaultForm(defaultForm.images, formName);
    }

    return PokemonForm(
        id: id,
        name: name,
        formName: formName,
        displayFormName: displayFormName,
        parentPokemon: parentPokemon,
        images: images
    );
  }
}
import 'package:pokedex_app/data/models/pokemon_form.model.dart';
import 'package:pokedex_app/data/models/pokemon_image.model.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';
import 'package:pokedex_app/data/models/pokemon_type.model.dart';
import 'package:pokedex_app/data/models/pokemon_stats.model.dart';

class Pokemon {

  final int id;
  final String name;
  final PokemonImage images;
  final PokemonStats stats;
  final PokemonType primaryType;
  final PokemonType? secondaryType;
  final List<PokemonForm> forms;
  final PokemonSpecies parentSpecies;

  Pokemon({
    required this.id,
    required this.name,
    required this.images,
    required this.stats,
    required this.primaryType,
    this.secondaryType,
    List<PokemonForm>? forms,
    required this.parentSpecies,
  }) : forms = forms ?? [];

  Map<PokemonType, double> get effectiveness {
    final effectiveness = <PokemonType, double>{
      PokemonType.normal: 1,
      PokemonType.fire: 1,
      PokemonType.water: 1,
      PokemonType.grass: 1,
      PokemonType.electric: 1,
      PokemonType.ice: 1,
      PokemonType.fighting: 1,
      PokemonType.poison: 1,
      PokemonType.ground: 1,
      PokemonType.flying: 1,
      PokemonType.psychic: 1,
      PokemonType.bug: 1,
      PokemonType.rock: 1,
      PokemonType.ghost: 1,
      PokemonType.dragon: 1,
      PokemonType.dark: 1,
      PokemonType.steel: 1,
      PokemonType.fairy: 1,
    };

    void applyTypeEffectiveness(PokemonType type) {
      for (var weakness in type.weaknesses) {
        effectiveness[weakness] = effectiveness[weakness]! * 2;
      }
      for (var resistance in type.resistances) {
        effectiveness[resistance] = effectiveness[resistance]! / 2;
      }
      for (var immunity in type.immunities) {
        effectiveness[immunity] = 0;
      }
    }
    applyTypeEffectiveness(primaryType);
    if (secondaryType != null) {
      applyTypeEffectiveness(secondaryType!);
    }
    return effectiveness;
  }

  PokemonForm get defaultForm {
    return forms.first;
  }

  factory Pokemon.fromJson(Map<String, dynamic> json, PokemonSpecies parentSpecies) {
    int id = json['id'];
    String name = parentSpecies.name;
    PokemonImage images = PokemonImage.fromJson(json['sprites']);
    PokemonStats stats = PokemonStats.fromJson(json['stats']);
    PokemonType primaryType = PokemonType.fromString(json['types']
        .firstWhere((type) => type['slot'] == 1)['type']['name']);
    PokemonType? secondaryType;
    if (json['types'].length > 1) {
      secondaryType = PokemonType.fromString(json['types']
          .firstWhere((type) => type['slot'] == 2)['type']['name']);
    }

    return Pokemon(
        id: id,
        name: name,
        images: images,
        stats: stats,
        primaryType: primaryType,
        secondaryType: secondaryType,
        parentSpecies: parentSpecies
    );
  }

  PokemonForm? getFormByName(String formName) {
    for (var form in forms) {
      if (form.formName.toLowerCase() == formName.toLowerCase()) {
        return form;
      }
    }
    return null;
  }
}


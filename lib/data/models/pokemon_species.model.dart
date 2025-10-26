import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_form.model.dart';

class PokemonSpecies {
  final int id;
  final String name;
  final int generation;
  final bool isLegendary;
  final bool isMythical;
  final bool hasGenderDifferences;
  PokemonSpecies? preEvolution;
  final List<PokemonSpecies> evolutions;
  final List<Pokemon> variants;

  Pokemon get defaultVariant => variants.first;

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    String name = json['names']
        .firstWhere((n) => n['language']['name'] == 'en')['name'];
    int generation = int.parse(
      json['generation']['url'].split('/')[6]
    );
    bool isLegendary = json['is_legendary'];
    bool isMythical = json['is_mythical'];
    bool hasGenderDifferences = json['has_gender_differences'];

    return PokemonSpecies(
      id: id,
      name: name,
      generation: generation,
      isLegendary: isLegendary,
      isMythical: isMythical,
      hasGenderDifferences: hasGenderDifferences,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'generation': generation,
      'is_legendary': isLegendary,
      'is_mythical': isMythical,
      'has_gender_differences': hasGenderDifferences,
    };
  }

  (Pokemon, PokemonForm) getByFormName(String formName) {
    for (var variant in variants) {
      PokemonForm? form = variant.getFormByName(formName);
      if (form != null) {
        return (variant, form);
      }
    }
    return (defaultVariant, defaultVariant.defaultForm);
  }

  PokemonSpecies({
    required this.id,
    required this.name,
    required this.generation,
    required this.isLegendary,
    required this.isMythical,
    required this.hasGenderDifferences,
    this.preEvolution,
    List<PokemonSpecies>? evolutions,
    List<Pokemon>? variants,
  })  : evolutions = evolutions ?? [],
        variants = variants ?? [];


}
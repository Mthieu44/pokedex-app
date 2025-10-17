enum PokemonType {
  normal(1, "normal", "assets/images/types/normal.svg"),
  fire(2, "fire", "assets/images/types/fire.svg"),
  water(3, "water", "assets/images/types/water.svg"),
  grass(4, "grass", "assets/images/types/grass.svg"),
  electric(5, "electric", "assets/images/types/electric.svg"),
  ice(6, "ice", "assets/images/types/ice.svg"),
  fighting(7, "fighting", "assets/images/types/fighting.svg"),
  poison(8, "poison", "assets/images/types/poison.svg"),
  ground(9, "ground", "assets/images/types/ground.svg"),
  flying(10, "flying", "assets/images/types/flying.svg"),
  psychic(11, "psychic", "assets/images/types/psychic.svg"),
  bug(12, "bug", "assets/images/types/bug.svg"),
  rock(13, "rock", "assets/images/types/rock.svg"),
  ghost(14, "ghost", "assets/images/types/ghost.svg"),
  dragon(15, "dragon", "assets/images/types/dragon.svg"),
  dark(16, "dark", "assets/images/types/dark.svg"),
  steel(17, "steel", "assets/images/types/steel.svg"),
  fairy(18, "fairy", "assets/images/types/fairy.svg");

  final int id;
  final String name;
  final String image;

  const PokemonType(this.id, this.name, this.image);

  static PokemonType fromString(String type) {
    return PokemonType.values.firstWhere(
      (e) => e.name.toLowerCase() == type.toLowerCase(),
      orElse: () => PokemonType.normal,
    );
  }


}

const Map<PokemonType, List<PokemonType>> typeWeaknesses = {
  PokemonType.normal: [PokemonType.fighting],
  PokemonType.fire: [PokemonType.water, PokemonType.ground, PokemonType.rock],
  PokemonType.water: [PokemonType.electric, PokemonType.grass],
  PokemonType.grass: [PokemonType.fire, PokemonType.ice, PokemonType.poison, PokemonType.flying, PokemonType.bug],
  PokemonType.electric: [PokemonType.ground],
  PokemonType.ice: [PokemonType.fire, PokemonType.fighting, PokemonType.rock, PokemonType.steel],
  PokemonType.fighting: [PokemonType.flying, PokemonType.psychic, PokemonType.fairy],
  PokemonType.poison: [PokemonType.ground, PokemonType.psychic],
  PokemonType.ground: [PokemonType.water, PokemonType.grass, PokemonType.ice],
  PokemonType.flying: [PokemonType.electric, PokemonType.ice, PokemonType.rock],
  PokemonType.psychic: [PokemonType.bug, PokemonType.ghost, PokemonType.dark],
  PokemonType.bug: [PokemonType.fire, PokemonType.flying, PokemonType.rock],
  PokemonType.rock: [PokemonType.water, PokemonType.grass, PokemonType.fighting, PokemonType.ground, PokemonType.steel],
  PokemonType.ghost: [PokemonType.ghost, PokemonType.dark],
  PokemonType.dragon: [PokemonType.ice, PokemonType.dragon, PokemonType.fairy],
  PokemonType.dark: [PokemonType.fighting, PokemonType.bug, PokemonType.fairy],
  PokemonType.steel: [PokemonType.fire, PokemonType.fighting, PokemonType.ground],
  PokemonType.fairy: [PokemonType.poison, PokemonType.steel],
};

extension PokemonTypeWeaknessExtension on PokemonType {
  List<PokemonType> get weaknesses => typeWeaknesses[this] ?? [];
}

const Map<PokemonType, List<PokemonType>> typeResistances = {
  PokemonType.normal: [],
  PokemonType.fire: [PokemonType.fire, PokemonType.grass, PokemonType.ice, PokemonType.bug, PokemonType.steel, PokemonType.fairy],
  PokemonType.water: [PokemonType.fire, PokemonType.water, PokemonType.ice, PokemonType.steel],
  PokemonType.grass: [PokemonType.water, PokemonType.electric, PokemonType.grass, PokemonType.ground],
  PokemonType.electric: [PokemonType.electric, PokemonType.flying, PokemonType.steel],
  PokemonType.ice: [PokemonType.ice],
  PokemonType.fighting: [PokemonType.bug, PokemonType.rock, PokemonType.dark],
  PokemonType.poison: [PokemonType.grass, PokemonType.fighting, PokemonType.poison, PokemonType.bug, PokemonType.fairy],
  PokemonType.ground: [PokemonType.poison, PokemonType.rock],
  PokemonType.flying: [PokemonType.grass, PokemonType.fighting, PokemonType.bug],
  PokemonType.psychic: [PokemonType.fighting, PokemonType.psychic],
  PokemonType.bug: [PokemonType.grass, PokemonType.fighting, PokemonType.ground],
  PokemonType.rock: [PokemonType.normal, PokemonType.fire, PokemonType.poison, PokemonType.flying],
  PokemonType.ghost: [PokemonType.poison, PokemonType.bug],
  PokemonType.dragon: [PokemonType.fire, PokemonType.water, PokemonType.electric, PokemonType.grass],
  PokemonType.dark: [PokemonType.ghost, PokemonType.dark],
  PokemonType.steel: [PokemonType.normal, PokemonType.grass, PokemonType.ice, PokemonType.flying, PokemonType.psychic, PokemonType.bug, PokemonType.rock, PokemonType.dragon, PokemonType.steel, PokemonType.fairy],
  PokemonType.fairy: [PokemonType.fighting, PokemonType.bug, PokemonType.dark],
};

extension PokemonTypeResistanceExtension on PokemonType {
  List<PokemonType> get resistances => typeResistances[this] ?? [];
}

const Map<PokemonType, List<PokemonType>> typeImmunities = {
  PokemonType.normal: [PokemonType.ghost],
  PokemonType.ground: [PokemonType.electric],
  PokemonType.flying: [PokemonType.ground],
  PokemonType.ghost: [PokemonType.normal, PokemonType.fighting],
  PokemonType.dark: [PokemonType.psychic],
  PokemonType.steel: [PokemonType.poison],
  PokemonType.fairy: [PokemonType.dragon],
};

extension PokemonTypeImmunityExtension on PokemonType {
  List<PokemonType> get immunities => typeImmunities[this] ?? [];
}

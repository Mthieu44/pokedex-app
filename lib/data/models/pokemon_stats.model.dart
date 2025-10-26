class PokemonStats{
  const PokemonStats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed
  });

  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;

  int get total {
    return hp + attack + defense + specialAttack + specialDefense + speed;
  }

  factory PokemonStats.fromJson(List<dynamic> json) {
    int hp;
    int attack;
    int defense;
    int specialAttack;
    int specialDefense;
    int speed;

    hp = json.firstWhere((stat) => stat['stat']['name'] == 'hp')['base_stat'];
    attack = json.firstWhere((stat) => stat['stat']['name'] == 'attack')['base_stat'];
    defense = json.firstWhere((stat) => stat['stat']['name'] == 'defense')['base_stat'];
    specialAttack = json.firstWhere((stat) => stat['stat']['name'] == 'special-attack')['base_stat'];
    specialDefense = json.firstWhere((stat) => stat['stat']['name'] == 'special-defense')['base_stat'];
    speed = json.firstWhere((stat) => stat['stat']['name'] == 'speed')['base_stat'];

    return PokemonStats(
      hp: hp,
      attack: attack,
      defense: defense,
      specialAttack: specialAttack,
      specialDefense: specialDefense,
      speed: speed
    );
  }
}
class PokemonRef {
  const PokemonRef({
    required this.id,
    required this.name
  });

  final int id;
  final String name;

  static PokemonRef mock() => const PokemonRef(
    id: 999,
    name: "MockRef"
  );
}
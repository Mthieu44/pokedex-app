enum PokemonImageType {
  artwork,
  artworkShiny,
  sprite2D,
  sprite2DShiny,
  sprite3D,
  sprite3DShiny,
  animatedSprite2D,
  animatedSprite2DShiny,
  animatedSprite3D,
  animatedSprite3DShiny,
}

extension PokemonImageTypeShiny on PokemonImageType {
  PokemonImageType get shiny {
    switch (this) {
      case PokemonImageType.artwork:
        return PokemonImageType.artworkShiny;
      case PokemonImageType.sprite2D:
        return PokemonImageType.sprite2DShiny;
      case PokemonImageType.sprite3D:
        return PokemonImageType.sprite3DShiny;
      case PokemonImageType.animatedSprite2D:
        return PokemonImageType.animatedSprite2DShiny;
      case PokemonImageType.animatedSprite3D:
        return PokemonImageType.animatedSprite3DShiny;
      default:
        return this;
    }
  }
}

class PokemonImage {
  final String? artwork;
  final String? artworkShiny;
  final String? sprite2D;
  final String? sprite2DShiny;
  final String? sprite3D;
  final String? sprite3DShiny;
  final String? animatedSprite2D;
  final String? animatedSprite2DShiny;
  final String? animatedSprite3D;
  final String? animatedSprite3DShiny;

  const PokemonImage({
    this.artwork,
    this.artworkShiny,
    this.sprite2D,
    this.sprite2DShiny,
    this.sprite3D,
    this.sprite3DShiny,
    this.animatedSprite2D,
    this.animatedSprite2DShiny,
    this.animatedSprite3D,
    this.animatedSprite3DShiny,
  });

  factory PokemonImage.fromJson(Map<String, dynamic> json) {
    String? artwork = json['other']['official-artwork']['front_default'];
    String? artworkShiny = json['other']['official-artwork']['front_shiny'];
    String? sprite2D = json['front_default'];
    String? sprite2DShiny = json['front_shiny'];
    String? sprite3D = json['other']['home']['front_default'];
    String? sprite3DShiny = json['other']['home']['front_shiny'];
    String? animatedSprite2D = json['versions']['generation-v']['black-white']['animated']['front_default'];
    String? animatedSprite2DShiny = json['versions']['generation-v']['black-white']['animated']['front_shiny'];
    String? animatedSprite3D = json['other']['showdown']['front_default'];
    String? animatedSprite3DShiny = json['other']['showdown']['front_shiny'];

    return PokemonImage(
      artwork: artwork,
      artworkShiny: artworkShiny,
      sprite2D: sprite2D,
      sprite2DShiny: sprite2DShiny,
      sprite3D: sprite3D,
      sprite3DShiny: sprite3DShiny,
      animatedSprite2D: animatedSprite2D,
      animatedSprite2DShiny: animatedSprite2DShiny,
      animatedSprite3D: animatedSprite3D,
      animatedSprite3DShiny: animatedSprite3DShiny,
    );
  }

  factory PokemonImage.fromId(int id) {
    final apiurl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon";
    return PokemonImage(
      artwork: "$apiurl/other/official-artwork/$id.png", // toujours disponible sauf formes
      artworkShiny: "$apiurl/other/official-artwork/shiny/$id.png", // toujours disponible sauf formes
      sprite2D: "$apiurl/$id.png", // toujours disponible // forme = /$id-<forme_name>.png
      sprite2DShiny: "$apiurl/shiny/$id.png", // toujours disponible // forme = /shiny/$id-<forme_name>.png
      sprite3D: "$apiurl/other/home/$id.png", // toujours disponible sauf formes // forme = /other/home/$id-<forme_name>.png
      sprite3DShiny: "$apiurl/other/home/shiny/$id.png", // toujours disponible sauf formes // forme = /other/home/shiny/$id-<forme_name>.png
      animatedSprite2D: "$apiurl/versions/generation-v/black-white/animated/$id.gif",
      animatedSprite2DShiny: "$apiurl/versions/generation-v/black-white/animated/shiny/$id.gif",
      animatedSprite3D: "$apiurl/other/showdown/$id.gif", // forme = /other/showdown/$id-<forme_name>.gif
      animatedSprite3DShiny: "$apiurl/other/showdown/shiny/$id.gif", // forme = /other/showdown/shiny/$id-<forme_name>.gif
    );
  }

  factory PokemonImage.formFromDefaultForm(PokemonImage defaultFormImages, String formName) {
    return PokemonImage(
      artwork: null,
      artworkShiny: null,
      sprite2D: defaultFormImages.sprite2D?.replaceFirst('.png', '-$formName.png'),
      sprite2DShiny: defaultFormImages.sprite2DShiny?.replaceFirst('.png', '-$formName.png'),
      sprite3D: defaultFormImages.sprite3D?.replaceFirst('.png', '-$formName.png'),
      sprite3DShiny: defaultFormImages.sprite3DShiny?.replaceFirst('.png', '-$formName.png'),
      animatedSprite2D: defaultFormImages.animatedSprite2D?.replaceFirst('.gif', '-$formName.gif'),
      animatedSprite2DShiny: defaultFormImages.animatedSprite2DShiny?.replaceFirst('.gif', '-$formName.gif'),
      animatedSprite3D: defaultFormImages.animatedSprite3D?.replaceFirst('.gif', '-$formName.gif'),
      animatedSprite3DShiny: defaultFormImages.animatedSprite3DShiny?.replaceFirst('.gif', '-$formName.gif'),
    );
  }


  String getImageUrl(PokemonImageType type) {
    final Map<PokemonImageType, List<String?>> priority = {
      PokemonImageType.artwork: [artwork, sprite2D],
      PokemonImageType.artworkShiny: [artworkShiny, sprite2DShiny, artwork, sprite2D],
      PokemonImageType.sprite2D: [sprite2D, artwork],
      PokemonImageType.sprite2DShiny: [sprite2DShiny, artworkShiny, sprite2D, artwork],
      PokemonImageType.sprite3D: [sprite3D, sprite2D, artwork],
      PokemonImageType.sprite3DShiny: [sprite3DShiny, sprite2DShiny, artworkShiny, sprite2D, artwork],
      PokemonImageType.animatedSprite2D: [animatedSprite2D, sprite2D, artwork],
      PokemonImageType.animatedSprite2DShiny: [animatedSprite2DShiny, sprite2DShiny, artworkShiny, sprite2D, artwork],
      PokemonImageType.animatedSprite3D: [animatedSprite3D, sprite3D, sprite2D, artwork],
      PokemonImageType.animatedSprite3DShiny: [animatedSprite3DShiny, sprite3DShiny, animatedSprite2DShiny, sprite2DShiny, artworkShiny, sprite2D, artwork],
    };

    final candidates = priority[type]!;
    for (var url in candidates) {
      if (url != null && url.isNotEmpty) {
        return url;
      }
    }
    return '';
  }
}
final Set<String> _brokenImagesCache = {};

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
extension PokemonImageFallbacks on PokemonImage {
  List<String> getFallbackList(PokemonImageType type) {
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

    return priority[type]!.whereType<String>().where((url) => url.isNotEmpty).toList();
  }

  String getImageUrl(PokemonImageType type) {
    final list = getFallbackList(type);
    return list.isNotEmpty ? list.first : '';
  }
}
extension PokemonImageMaintenance on PokemonImage {
  void removeInvalidUrl(String url) {
    _brokenImagesCache.add(url);
    print(_brokenImagesCache);

    if (artwork == url) artwork = null;
    if (artworkShiny == url) artworkShiny = null;
    if (sprite2D == url) sprite2D = null;
    if (sprite2DShiny == url) sprite2DShiny = null;
    if (sprite3D == url) sprite3D = null;
    if (sprite3DShiny == url) sprite3DShiny = null;
    if (animatedSprite2D == url) animatedSprite2D = null;
    if (animatedSprite2DShiny == url) animatedSprite2DShiny = null;
    if (animatedSprite3D == url) animatedSprite3D = null;
    if (animatedSprite3DShiny == url) animatedSprite3DShiny = null;
  }

  bool isUrlBroken(String? url) => url == null || _brokenImagesCache.contains(url);
}

class PokemonImage {
  String? artwork;
  String? artworkShiny;
  String? sprite2D;
  String? sprite2DShiny;
  String? sprite3D;
  String? sprite3DShiny;
  String? animatedSprite2D;
  String? animatedSprite2DShiny;
  String? animatedSprite3D;
  String? animatedSprite3DShiny;

  PokemonImage({
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

  factory PokemonImage.formFromDefaultForm(PokemonImage defaultFormImages,
      String formName) {
    return PokemonImage(
      artwork: null,
      artworkShiny: null,
      sprite2D: defaultFormImages.sprite2D?.replaceFirst(
          '.png', '-$formName.png'),
      sprite2DShiny: defaultFormImages.sprite2DShiny?.replaceFirst(
          '.png', '-$formName.png'),
      sprite3D: defaultFormImages.sprite3D?.replaceFirst(
          '.png', '-$formName.png'),
      sprite3DShiny: defaultFormImages.sprite3DShiny?.replaceFirst(
          '.png', '-$formName.png'),
      animatedSprite2D: defaultFormImages.animatedSprite2D?.replaceFirst(
          '.gif', '-$formName.gif'),
      animatedSprite2DShiny: defaultFormImages.animatedSprite2DShiny
          ?.replaceFirst('.gif', '-$formName.gif'),
      animatedSprite3D: defaultFormImages.animatedSprite3D?.replaceFirst(
          '.gif', '-$formName.gif'),
      animatedSprite3DShiny: defaultFormImages.animatedSprite3DShiny
          ?.replaceFirst('.gif', '-$formName.gif'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon_image.model.dart';

class PokemonImageBubble extends StatelessWidget {
  final PokemonImage pokemonImage;
  final double size;
  final PokemonImageType type;
  final double zoom;
  const PokemonImageBubble({
    super.key, 
    required this.pokemonImage,
    this.size = 85,
    this.type = PokemonImageType.artwork,
    this.zoom = 1.0,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Transform.scale(
          scale: zoom,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size,
              maxHeight: size,
            ),
            child: Image.network(
                pokemonImage.getImageUrl(type),
                fit: BoxFit.contain
            ),
          ),
        ),
      ),
    );
  }
}
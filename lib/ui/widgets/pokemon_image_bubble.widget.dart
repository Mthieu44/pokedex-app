import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_image.model.dart';

class PokemonImageBubble extends StatefulWidget {
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
  State<PokemonImageBubble> createState() => _PokemonImageBubbleState();
}

class _PokemonImageBubbleState extends State<PokemonImageBubble> {
  late String currentUrl;

  @override
  void initState() {
    super.initState();
    currentUrl = widget.pokemonImage.getImageUrl(widget.type);
  }

  void _handleImageError() {
    widget.pokemonImage.removeInvalidUrl(currentUrl);
    final nextUrl = widget.pokemonImage.getImageUrl(widget.type);
    if (nextUrl != currentUrl) {
      Future.microtask(() {
        if (mounted) {
          setState(() {
            currentUrl = nextUrl;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Transform.scale(
          scale: widget.zoom,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: widget.size,
              maxHeight: widget.size,
            ),
            child: Image.network(
              currentUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                _handleImageError();
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
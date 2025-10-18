import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon_image.model.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';
import 'package:pokedex_app/ui/pages/pokemon_details.page.dart';
import 'package:pokedex_app/ui/theme/type_colors.theme.dart';
import 'package:pokedex_app/ui/widgets/pokemon_image_bubble.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_type_bubble.widget.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
      super.key,
      required this.pokemonSpecies
  });
  final PokemonSpecies pokemonSpecies;

  @override
  Widget build(BuildContext context) {

    final pokemon = pokemonSpecies.defaultVariant;
    
    final palette = TypeColors.getPalette(pokemon.primaryType.name);
    final imageType = PokemonImageType.artwork;
    
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: palette.secondary
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                PokemonDetailsPage(pokemonSpecies: pokemonSpecies)
              )
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                      pokemonSpecies.name,
                          style: const TextStyle(
                            color: Colors.white,
                          )
                      ),
                      Text(
                          "#${pokemonSpecies.id}",
                          style: const TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.bold
                          )
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          PokemonTypeBubbleWidget(type: pokemon.primaryType),
                          if (pokemon.secondaryType != null) ...[
                            SizedBox(height: 4),
                            PokemonTypeBubbleWidget(type: pokemon.secondaryType!)
                          ]
                        ],
                      ),
                    ),
                    Hero(
                      tag: 'pokemon_image_${pokemonSpecies.id}',
                      child: PokemonImageBubble(pokemonImage: pokemon.images, size: 80, type: imageType)
                    )
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
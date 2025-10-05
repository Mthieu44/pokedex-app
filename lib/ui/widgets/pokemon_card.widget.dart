import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_type.model.dart';
import 'package:pokedex_app/ui/theme/type_colors.theme.dart';
import 'package:pokedex_app/ui/widgets/pokemon_type_bubble.widget.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
      super.key,
      required this.pokemon
  });
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    
    final palette = TypeColors.getPalette(pokemon.primaryType.name);
    
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: palette.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    pokemon.name,
                    style: TextStyle(
                      color: Colors.white,
                    )
                ),
                Text(
                    "#${pokemon.pokedexId}",
                    style: TextStyle(
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
              Image.network(
                pokemon.image,
                width: 85
              )
            ],
          ),
        ],
      )
    );
  }
}
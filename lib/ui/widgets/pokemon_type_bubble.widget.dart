import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/data/models/pokemon_type.model.dart';
import 'package:pokedex_app/ui/theme/type_colors.theme.dart';

class PokemonTypeBubbleWidget extends StatelessWidget {
  const PokemonTypeBubbleWidget({
    super.key,
    required this.type
  });

  final PokemonType type;

  double getBubbleWidth() {
    const textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: "ELECTRIC", style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    // Largeur du texte + marge pour icône (20) +
    return textPainter.width + 20 + 4;
  }

  @override
  Widget build(BuildContext context) {

    final palette = TypeColors.getPalette(type.name);

    return Container(
      padding: EdgeInsets.only(right: 4),
      width: getBubbleWidth(),
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: BorderRadius.circular(120)
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            type.image,
            width: 20,
            height: 20,
          ),
          Expanded(
            child: Center(
              child: Text(
                type.name.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                )
              )
            ),
          )
        ],
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/models/pokemon_type.model.dart';

class TypeEffectivenessWidget extends StatelessWidget{
  final PokemonType type;
  final double effectiveness;
  
  const TypeEffectivenessWidget({super.key, required this.type, required this.effectiveness});

  Color getMultiplierColor(double mult) {
    switch (mult) {
      case 0.0: return Colors.grey;
      case 0.25: return Colors.green.shade600;
      case 0.5: return Colors.lightGreen;
      case 1.0: return Colors.black;
      case 2.0: return Colors.orange;
      case 4.0: return Colors.red;
    }

    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          type.image,
          width: 40,
        ),
        SizedBox(height: 4),
        Text(
          "${effectiveness}x",
          style: TextStyle(
            fontSize: 12,
            color: getMultiplierColor(effectiveness)
          ),
        ),
      ],
    );
  }
}
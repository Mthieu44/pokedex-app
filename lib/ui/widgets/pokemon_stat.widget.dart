

import 'package:flutter/material.dart';

class PokemonStatWidget extends StatelessWidget {

  final String statName;
  final int statValue;
  const PokemonStatWidget({
    super.key,
    required this.statName,
    required this.statValue,
  });

  Color _getBarColor(int value) {
    const colors = [
      Color(0xFFFF0C0C),
      Color(0xFFF98100),
      Color(0xFFFFFF0F),
      Color(0xFF00DA00),
      Color(0xFF006900),
    ];

    const stops = [0.0, 0.15, 0.3, 0.5, 1.0];

    double t = value / 255.0;

    for (int i = 0; i < stops.length - 1; i++) {
      final start = stops[i];
      final end = stops[i + 1];

      if (t >= start && t <= end) {
        final localT = (t - start) / (end - start);
        return Color.lerp(colors[i], colors[i + 1], localT)!;
      }
    }

    return colors.last;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              statName,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              statValue.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: LinearProgressIndicator(
              value: statValue / 255,
              backgroundColor: Colors.transparent,
              color: _getBarColor(statValue),
              borderRadius: BorderRadius.circular(2),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PokemonCardSkeleton extends StatelessWidget {
  final String imagePath = 'assets/images/substitute_doll_2d.png';
  const PokemonCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade300,
            ),
          ),
        ),

        Transform.scale(
          scale: 1.6,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            color: Colors.grey.shade300,
          ),
        )
      ],
    );
  }
}
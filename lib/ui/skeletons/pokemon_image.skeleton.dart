import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/skeletons/abstract.skeleton.dart';
import 'package:shimmer/shimmer.dart';

class PokemonImageSkeleton extends AbstractSkeleton{
  final String imagePath = 'assets/images/substitute_doll_2d.png';
  const PokemonImageSkeleton({
    super.key,
    super.size,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        height: size,
        child: Transform.scale(
          scale: 1.6,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            color: Colors.grey,
          ),
        )
      ),
    );
  }
}
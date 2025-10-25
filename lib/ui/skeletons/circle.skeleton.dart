import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/skeletons/abstract.skeleton.dart';
import 'package:shimmer/shimmer.dart';

class CircleSkeleton extends AbstractSkeleton {
  final double scale = 0.85;

  const CircleSkeleton({
    super.key,
    super.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: scale,
          heightFactor: scale,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/skeletons/abstract.skeleton.dart';
import 'package:pokedex_app/ui/skeletons/circle.skeleton.dart';

class ListSkeleton extends StatelessWidget {
  final int count;
  final double spacing;
  final Axis direction;
  final AbstractSkeleton skeleton;
  const ListSkeleton({
    super.key,
    this.count = 3,
    this.spacing = 0.0,
    this.direction = Axis.horizontal,
    this.skeleton = const CircleSkeleton(),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: direction,
      child: Center(
        child: Wrap(
          direction: direction,
          spacing: spacing,
          children: List.generate(
            count,
            (index) => skeleton,
          ),
        ),
      ),
    );
  }
}
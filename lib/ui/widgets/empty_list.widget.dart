import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final double size;
  final String imagePath = 'assets/images/substitute_doll_2d.png';
  const EmptyListWidget({
    super.key,
    this.size = 75.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Transform.scale(
        scale: 1.6,
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          color: Colors.grey.shade600,
        ),
      )
    );
  }
}
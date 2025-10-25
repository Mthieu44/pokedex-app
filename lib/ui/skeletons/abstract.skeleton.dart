import 'package:flutter/material.dart';

abstract class AbstractSkeleton extends StatelessWidget{
  final double size;
  const AbstractSkeleton({
    super.key,
    this.size = 75.0,
  });
}
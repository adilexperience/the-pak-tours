import 'dart:ui';

import 'package:flutter/material.dart';

class GlassmorphismedWidget extends StatelessWidget {
  final Widget child;
  final BorderRadius? radius;
  final EdgeInsetsGeometry? padding;
  final double? sigmaX, sigmaY;

  const GlassmorphismedWidget({
    Key? key,
    required this.child,
    this.radius,
    this.padding,
    this.sigmaX,
    this.sigmaY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.circular(10.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: sigmaX ?? 15,
          sigmaY: sigmaY ?? 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.20),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

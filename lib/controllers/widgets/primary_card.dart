import 'package:flutter/material.dart';

class PrimaryCard extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? cardColor;
  final List<BoxShadow>? boxShadow;
  final double horizontalPadding, verticalPadding;

  const PrimaryCard({
    Key? key,
    required this.child,
    this.onPressed,
    this.boxShadow,
    this.cardColor,
    this.horizontalPadding = 15.0,
    this.verticalPadding = 30.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: boxShadow,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: child,
      ),
    );
  }
}

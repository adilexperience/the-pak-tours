import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';

class TileCard extends StatelessWidget {
  final String? title;
  final Widget? child;
  final Color? bgColor, textColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onPressed;

  const TileCard({
    Key? key,
    this.title = "use title to change value",
    this.child,
    this.bgColor,
    this.textColor,
    this.padding,
    this.borderRadius = 10.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 20.0,
            ),
        child: child ??
            Text(
              title!,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}

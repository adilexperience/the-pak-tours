import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final Widget? child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final Color buttonColor, buttonTextColor;
  final bool? needShadow;
  final FontWeight? fontWeight;
  final TextAlign buttonTextAlignment;

  const PrimaryButton({
    Key? key,
    this.buttonText = "use buttonText property to assign value",
    this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 14.0),
    this.fontSize = 16.0,
    this.onPressed,
    this.buttonColor = AppColors.primary,
    this.buttonTextColor = Colors.white,
    this.needShadow = true,
    this.fontWeight,
    this.buttonTextAlignment = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: (needShadow == true)
              ? [
                  BoxShadow(
                    color: AppColors.strongText.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                    offset: const Offset(7, 4),
                  )
                ]
              : null,
        ),
        padding: padding,
        child: child ??
            Text(
              buttonText,
              style: TextStyle(
                color: buttonTextColor,
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w700,
              ),
              textAlign: buttonTextAlignment,
            ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';

class RichTextBottomSwitchScreen extends StatelessWidget {
  final String questionString, actionString;
  final Color questionColor, actionColor;
  final String? toRoute;

  const RichTextBottomSwitchScreen({
    Key? key,
    this.questionString = "Already have an account? ",
    this.actionString = "Log in",
    this.questionColor = Colors.white,
    this.actionColor = AppColors.secondary,
    this.toRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => toRoute == null
          ? null
          : Constants.pushNamedAndRemoveAll(context, toRoute!),
      child: Align(
        alignment: Alignment.center,
        child: Text.rich(
          TextSpan(
            style: GoogleFonts.nunito(
              fontSize: 16.0,
              color: questionColor,
            ),
            children: [
              TextSpan(
                text: questionString,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: actionString,
                style: GoogleFonts.nunito(
                  color: actionColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

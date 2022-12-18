import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DividerMiddleTitle extends StatelessWidget {
  final Color mainColor;
  const DividerMiddleTitle({
    Key? key,
    this.mainColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Divider(
          color: mainColor,
        )),
        Expanded(
          child: Text(
            'Or Alternatively',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: mainColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
            child: Divider(
          color: mainColor,
        )),
      ],
    );
  }
}

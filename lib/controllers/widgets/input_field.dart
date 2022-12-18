import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';

class InputField extends StatefulWidget {
  // required fields
  final bool isEmailField, isPasswordField;
  final IconData leadingIcon;
  final String fieldHint;
  final TextEditingController controller;
  final TextInputType? inputType;

  // optional fields
  final bool isEmailValidated;
  const InputField({
    Key? key,
    required this.leadingIcon,
    required this.fieldHint,
    required this.controller,
    this.isEmailField = false,
    this.inputType,
    this.isPasswordField = false,
    this.isEmailValidated = false,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isHiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 13,
      child: TextField(
        controller: widget.controller,
        style: GoogleFonts.inter(
          fontSize: 18.0,
          color: AppColors.strongText,
        ),
        obscureText: widget.isPasswordField && isHiddenPassword,
        maxLines: 1,
        keyboardType: widget.inputType ?? TextInputType.emailAddress,
        cursorColor: AppColors.strongText,
        decoration: InputDecoration(
          hintText: widget.fieldHint,
          hintStyle: GoogleFonts.inter(
            fontSize: 16.0,
            color: AppColors.strongText.withOpacity(0.5),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(248, 247, 251, 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.controller.text.trim().isEmpty
                  ? Colors.transparent
                  : AppColors.primary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primary,
            ),
          ),
          prefixIcon: Icon(
            widget.leadingIcon,
            color: widget.controller.text.trim().isEmpty
                ? AppColors.strongText.withOpacity(0.5)
                : AppColors.primary,
            size: 16,
          ),
          suffix: widget.isEmailField
              ? widget.isEmailValidated
                  ? Container(
                      alignment: Alignment.center,
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: AppColors.primary,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 13,
                      ),
                    )
                  : const SizedBox.shrink()
              : widget.isPasswordField
                  ? InkWell(
                      onTap: () => togglePassword(),
                      child: Container(
                        height: 30,
                        width: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(249, 225, 224, 1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.secondary,
                          ),
                        ),
                        child: Text(
                          isHiddenPassword ? 'View' : "Hide",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
        ),
      ),
    );
  }

  void togglePassword() {
    isHiddenPassword = !isHiddenPassword;
    setState(() {});
  }
}

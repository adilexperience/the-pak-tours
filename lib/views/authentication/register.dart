import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isEmailValidated = false,
      isPasswordValidated = false,
      isRepPasswordValidated = false,
      isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController repPassController = TextEditingController();

  @override
  void initState() {
    listenToControllers();
    super.initState();
  }

  void listenToControllers() {
    emailController.addListener(() {
      isEmailValidated =
          Constants.isEmailValid(emailController.text.toString().trim());
      setState(() {});
    });

    passController.addListener(() {
      isPasswordValidated =
          Constants.isPasswordValidated(passController.text.toString().trim());
      setState(() {});
    });

    repPassController.addListener(() {
      isRepPasswordValidated =
          passController.text.trim() == repPassController.text.trim();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primary.withOpacity(0.85),
      body: Stack(
        children: [
          SafeArea(
            child: SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  //left side background design. I use a svg image here
                  Positioned(
                    left: -34,
                    top: 181.0,
                    child: SvgPicture.string(
                      // Group 3178
                      '<svg viewBox="-34.0 181.0 99.0 99.0" ><path transform="translate(-34.0, 181.0)" d="M 74.25 0 L 99 49.5 L 74.25 99 L 24.74999618530273 99 L 0 49.49999618530273 L 24.7500057220459 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-26.57, 206.25)" d="M 0 0 L 42.07500076293945 16.82999992370605 L 84.15000152587891 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(15.5, 223.07)" d="M 0 56.42999649047852 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                      width: 99.0,
                      height: 99.0,
                    ),
                  ),

                  //right side background design. I use a svg image here
                  Positioned(
                    right: -52,
                    top: 45.0,
                    child: SvgPicture.string(
                      // Group 3177
                      '<svg viewBox="288.0 45.0 139.0 139.0" ><path transform="translate(288.0, 45.0)" d="M 104.25 0 L 139 69.5 L 104.25 139 L 34.74999618530273 139 L 0 69.5 L 34.75000762939453 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(298.42, 80.45)" d="M 0 0 L 59.07500076293945 23.63000106811523 L 118.1500015258789 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(357.5, 104.07)" d="M 0 79.22999572753906 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                      width: 139.0,
                      height: 139.0,
                    ),
                  ),

                  //content ui
                  Positioned(
                    top: 8.0,
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.06),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //logo section
                            Column(
                              children: [
                                logo(size.height / 8, size.height / 8),
                                const SizedBox(height: 8),
                                richText(23.12),
                              ],
                            ),
                            const SizedBox(height: 8),
                            //continue with email for sign in app text
                            Text(
                              'Register with us and start exploring right away.',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            //email and password TextField here
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InputField(
                                  leadingIcon: Icons.person,
                                  fieldHint: "Enter your name",
                                  controller: nameController,
                                ),
                                const SizedBox(height: 8),
                                InputField(
                                  leadingIcon: Icons.email,
                                  fieldHint: "Enter your email address",
                                  isEmailField: true,
                                  isEmailValidated: isEmailValidated,
                                  controller: emailController,
                                ),
                                const SizedBox(height: 8),
                                InputField(
                                  leadingIcon: Icons.lock,
                                  fieldHint: "Enter your password",
                                  isPasswordField: true,
                                  controller: passController,
                                ),
                                const SizedBox(height: 8),
                                InputField(
                                  leadingIcon: Icons.email_outlined,
                                  fieldHint: "Re-type your password",
                                  isPasswordField: true,
                                  controller: repPassController,
                                ),
                                const SizedBox(height: 24),
                                PrimaryButton(
                                  buttonText: "Register",
                                  onPressed: () => processRegistration(),
                                ),
                              ],
                            ),
                            //footer section. google, facebook button and sign up text here
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: const [
                                  SizedBox(height: 16),
                                  DividerMiddleTitle(),
                                  SizedBox(height: 16),
                                  RichTextBottomSwitchScreen(
                                    toRoute: AppRoutes.loginRoute,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading ? const LoadingOverlay() : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return SvgPicture.asset(
      'assets/logo2.svg',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: 23.12,
          color: Colors.white,
          letterSpacing: 1.999999953855673,
        ),
        children: const [
          TextSpan(
            text: 'REGISTER',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'PAGE',
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  void processRegistration() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passController.text.trim();

    if (name.isEmpty) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(message: "Please enter your name"),
      );
    } else if (!isEmailValidated) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
            message: "Please enter valid email address to proceed"),
      );
    } else if (!isPasswordValidated || !isRepPasswordValidated) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
            message:
                "Please enter strong password and repeat password should be same"),
      );
    } else {
      setLoading(true);

      await ApiRequests.registerTourist(
        name,
        email,
        password,
        context: context,
      ).then((value) {
        showTopSnackBar(
          context,
          const CustomSnackBar.success(
            message:
                "Email verification link sent, please verify your email-address to login",
          ),
        );
        ApiRequests.signOut(context);
      }).onError((error, stackTrace) {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: error.toString(),
          ),
        );
      });

      setLoading(false);
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    setState(() {});
  }
}

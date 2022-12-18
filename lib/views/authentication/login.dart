import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/views/views_exporter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false, isEmailValidated = false, isPasswordValidated = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Column(
            children: [
              //to give space card from top
              const Expanded(
                flex: 1,
                child: Center(),
              ),

              //page content
              Expanded(
                flex: 11,
                child: buildCard(size),
              ),
            ],
          ),
          isLoading ? const LoadingOverlay() : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //build minimize icon
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 35,
                height: 4.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            //welcome text
            Text(
              'Welcome Back!',
              style: GoogleFonts.inter(
                fontSize: 22.0,
                color: AppColors.strongText,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              'Let’s login for explore continues',
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: AppColors.lightText,
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),

            //logo section
            logo(size.height / 12, size.height / 12),
            SizedBox(
              height: size.height * 0.02,
            ),
            richText(24),
            SizedBox(
              height: size.height * 0.03,
            ),

            //email textField
            Text(
              'Email Address',
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            InputField(
              controller: emailController,
              fieldHint: "Enter your email address",
              leadingIcon: Icons.email_outlined,
              isEmailField: true,
              isEmailValidated: isEmailValidated,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            //password textField
            Text(
              'Password',
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            InputField(
              controller: passController,
              fieldHint: "Enter your password",
              leadingIcon: Icons.lock_outline_rounded,
              isPasswordField: true,
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () =>
                      Constants.pushNamed(context, AppRoutes.forgetRoute),
                  child: const Text(
                    "Forget password?",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            //sign in button
            PrimaryButton(
              buttonText: "Sign In",
              onPressed: () => processLogin(),
            ),
            const SizedBox(height: 16),
            const DividerMiddleTitle(mainColor: AppColors.lightText),
            const SizedBox(height: 16),
            RichTextBottomSwitchScreen(
              questionString: "Don't have an already? ",
              actionString: "Register now",
              questionColor: AppColors.strongText.withOpacity(0.65),
              actionColor: AppColors.secondary,
              toRoute: AppRoutes.registerRoute,
            ),
          ],
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return SvgPicture.asset(
      'assets/logo.svg',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: AppColors.primary,
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: 'LOGIN',
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

  void processLogin() async {
    String email = emailController.text.toString().trim();
    String password = passController.text.toString().trim();

    if (!isEmailValidated) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
          message: "Please enter valid email-address to proceed",
        ),
      );
    } else if (!isPasswordValidated) {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
          message: "Type your correct password to proceed.",
        ),
      );
    } else {
      setLoading(true);

      await ApiRequests.login(email, password, context: context);
      setLoading(false);

      if (ApiRequests.checkEmailVerificationStatus()) {
        Constants.pushAndRemoveAll(context, Dashboard());
      } else {
        await ApiRequests.sendEmailVerificationLink();
        showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message:
                "Verify your email-address to login. link shared at your email-address",
          ),
        );
        ApiRequests.signOut(context);
      }
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    setState(() {});
  }
}

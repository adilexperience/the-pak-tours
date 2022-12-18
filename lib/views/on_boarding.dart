import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../controllers/controllers_exporter.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({
    Key? key,
  }) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: [
          PageViewModel(
            title: "Welcome to PakTours",
            body:
                "We have different locations available with guidance and hand crafted specialised products specific to region you're interested in to enhance your trip.",
            image: Image.asset(LocalAssets.onBoardingOne),
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                color: AppColors.secondary,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.9,
              ),
              bodyTextStyle: TextStyle(
                color: AppColors.lightText,
                fontSize: 15.0,
              ),
            ),
          ),
          PageViewModel(
            title: "Hand Crafted Products",
            body:
                "Whichever location you chose you visit, you will find authentic hand picked sellers having local products specific to that place. ",
            image: Image.asset(
              LocalAssets.onBoardingTwo,
              width: 300.0,
            ),
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                color: Colors.orange,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.9,
              ),
              bodyTextStyle: TextStyle(
                color: AppColors.lightText,
                fontSize: 15.0,
              ),
            ),
          ),
          PageViewModel(
            title: "Personalized Guide and location updates",
            body:
                "We look ahead of time for you to be safe, you will find weather conditions, accessibility options and nearby restaurants to stay.",
            image: Image.asset(
              LocalAssets.onBoardingThree,
              width: 300.0,
            ),
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                color: Colors.red,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.9,
              ),
              bodyTextStyle: TextStyle(
                color: AppColors.lightText,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
        onDone: () =>
            Constants.pushNamedAndRemoveAll(context, AppRoutes.loginRoute),
        onSkip: () =>
            Constants.pushNamedAndRemoveAll(context, AppRoutes.loginRoute),
        showSkipButton: true,
        skip: Text(
          "Skip".toUpperCase(),
          style: const TextStyle(
            color: AppColors.secondary,
            fontSize: 19.0,
          ),
        ),
        next: Text(
          "Next".toUpperCase(),
          style: TextStyle(
            color: AppColors.secondary.withOpacity(0.6),
            fontSize: 19.0,
          ),
        ),
        done: const Text(
          "Done",
          style: TextStyle(
            fontSize: 19.0,
            color: Colors.red,
          ),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(
            horizontal: 3.0,
          ),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              25.0,
            ),
          ),
        ),
      ),
    );
  }
}

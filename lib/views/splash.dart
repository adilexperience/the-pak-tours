import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    processSplash();
    super.initState();
  }

  // process splash - Check if user is opening the app for first time or not.
  // If first time then take to On-boarding otherwise dashboard
  void processSplash() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (Persistent.isNotFirstTime == null) {
        // this means its first visit of user to app
        // take user to on-boarding
        Persistent.recordUserFirstVisit();
        Constants.pushNamedAndRemoveAll(context, AppRoutes.onBoardingRoute);
      } else {
        // take user to auth handler to then redirect to either login or dashboard
        // its not user's first visit
        if (FirebaseAuth.instance.currentUser == null) {
          Constants.pushNamedAndRemoveAll(context, AppRoutes.loginRoute);
        } else {
          Constants.pushNamedAndRemoveAll(context, AppRoutes.dashboardRoute);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(LocalAssets.splashBackground),
            fit: BoxFit.fill,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(flex: 2, child: SizedBox.shrink()),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Explore Pakistan",
                        style: TextStyle(
                          fontSize: 55.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Numerous un-discovered heritage locations near you waiting to get explored.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

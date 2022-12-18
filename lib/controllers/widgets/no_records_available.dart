import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';

class NoRecordsAvailable extends StatelessWidget {
  final String title, description;
  const NoRecordsAvailable({
    Key? key,
    this.title = "No places in your wishlist",
    this.description =
        "Take first step and start exploring beautiful places of pakistan.",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Lottie.asset(
              "assets/animations/explore.json",
              width: 100.0,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.strongText,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.lightText,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';

class Constants {
  // firebase constants
  static const String placesCollection = "Places";
  static const String notificationsCollection = "Notifications";
  static const String wishListsCollection = "Wishlists";
  static const String ordersCollection = "Orders";
  static const String usersCollection = "Users";
  static const String productsCollection = "Products";
  static const String reviewsCollection = "Reviews";

  static const String profilePictures = "ProfilePictures";

  // persistent constants
  static const String persistentLoggedUser = "PersistentLoggedUser";

  static String applicationName = "PakTours";

  static int nearbyPlacesDistanceInKilometers = 10;
  static int nearbySellerDistanceInKilometers = 20;
  static double mapDefaultZoom = 15.0746;

  static void pushNamed(BuildContext context, String destination) {
    Navigator.of(context).pushNamed(destination);
  }

  static void pushNamedAndRemoveAll(BuildContext context, String destination) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      destination,
      (route) => false,
    );
  }

  static void pushAndRemoveAll(BuildContext context, Widget destination) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  static push(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => destination,
      ),
    );
  }

  static pop(BuildContext context) {
    Navigator.pop(context);
  }

  static bool isEmailValid(String email) {
    return email.isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }

  static bool isPasswordValidated(String password) {
    return password.isNotEmpty && password.length >= 8;
  }

  static showTwoButtonDialog({
    required BuildContext context,
    String? dialogMessage,
    Widget? child,
    bool isDismissible = true,
    String primaryButtonText = "Accept",
    String secondaryButtonText = "Decline",
    VoidCallback? onPressed,
    VoidCallback? secondaryOnPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AlertDialog(
        title: Text(
          Constants.applicationName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: child ?? Text(dialogMessage!),
        actions: <Widget>[
          InkWell(
            onTap: secondaryOnPressed ?? () => Navigator.pop(context),
            child: Text(
              secondaryButtonText,
              style: const TextStyle(
                color: AppColors.strongText,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8.0),
          PrimaryButton(
            onPressed: onPressed ?? () => Navigator.pop(context),
            buttonText: primaryButtonText,
            fontSize: 14.0,
            // padding: const EdgeInsets.symmetric(
            //   horizontal: 20.0,
            //   vertical: 8.0,
            // ),
          ),
        ],
      ),
    );
  }

  static double getDistance(LatLng currentLocation, LatLng destinationLocation,
      {bool responseInKilometer = true}) {
    double distanceInMeters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      destinationLocation.latitude,
      destinationLocation.longitude,
    );
    double distanceInKilometers = distanceInMeters / 1000;
    if (responseInKilometer) {
      return distanceInKilometers;
    } else {
      return distanceInMeters;
    }
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_pak_tours/controllers/controllers_exporter.dart';
import 'package:the_pak_tours/models/models_exporter.dart';
import 'package:the_pak_tours/views/views_exporter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ApiRequests {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static bool get isLoggedIn =>
      (_firebaseAuth.currentUser == null) ? false : true;

  static Future<UserModel> getLoggedInUser() async {
    UserModel? _user;
    await _firebaseFirestore
        .collection(Constants.usersCollection)
        .doc(_firebaseAuth.currentUser?.uid)
        .get()
        .then((user) {
      _user = UserModel.fromJson(user.data() as Map<String, dynamic>);
    });
    return _user!;
  }

  static Future<void> updateUsername(String username) async {
    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(username);
      await _firebaseFirestore
          .collection(Constants.usersCollection)
          .doc(_firebaseAuth.currentUser?.uid)
          .update({
        "name": username,
      });
    } on Exception catch (e) {
      rethrow;
    }
  }

  static Future<void> login(String email, String password,
      {required BuildContext context}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      return true;
    }).onError((error, stackTrace) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: error.toString(),
        ),
      );
      return false;
    });
  }

  static Future<void> getRecoveryPasswordLink(String email,
      {required BuildContext context}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      showTopSnackBar(
        context,
        const CustomSnackBar.success(
          message: "Instructions shared on your associated email address",
        ),
      );
      return true;
    }).onError((error, stackTrace) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(message: error.toString()),
      );
      return false;
    });
  }

  static Future<void> registerTourist(String username, String email, String uid,
      {required BuildContext context}) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: uid)
        .then((value) async {
      await storeUserRecord(
        value.user!.uid,
        username,
        email,
        uid,
        context: context,
      );
      await sendEmailVerificationLink();
    }).onError((error, stackTrace) {
      throw (error!);
    });
  }

  static Future<void> storeUserRecord(
      String id, String username, String email, String uid,
      {required BuildContext context}) async {
    DocumentReference usersReference =
        _firebaseFirestore.collection(Constants.usersCollection).doc(id);
    UserModel user = UserModel(
      id: id,
      name: username,
      emailAddress: email,
      roles: ["tourist"],
      joinedAt: Timestamp.now(),
      isAllowed: true,
      imageUrl: "",
    );
    await usersReference.set(user.toJson());
  }

  static Future<Position> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Constants.showTwoButtonDialog(
        context: context,
        dialogMessage:
            "Location services are disabled. Grant location permissions for this app to function properly, otherwise app will not function properly",
        primaryButtonText: "Okay",
        onPressed: () => Geolocator.openLocationSettings(),
        secondaryButtonText: "Not now",
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Constants.showTwoButtonDialog(
          context: context,
          dialogMessage:
              "Grant location permissions for this app to function properly, otherwise app will not function properly",
          primaryButtonText: "Okay",
          onPressed: () => Geolocator.openLocationSettings(),
          secondaryButtonText: "Not now",
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Constants.showTwoButtonDialog(
        context: context,
        dialogMessage:
            "Location permissions are permanently denied, we cannot request permissions. grant permission from settings, otherwise app will not function properly",
        primaryButtonText: "Okay",
        onPressed: () => Geolocator.openLocationSettings(),
        secondaryButtonText: "Not now",
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<List<UserModel>> getAllUsers({String type = "seller"}) async {
    List<UserModel> users = [];
    await _firebaseFirestore
        .collection(Constants.usersCollection)
        .where("roles", arrayContains: type)
        .orderBy("joined_at", descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        users.add(UserModel.fromJson(element.data()));
      });
    });
    return users;
  }

  static Future<List<UserModel>> getNearbySellers(
      GeoPoint placeLocation) async {
    List<UserModel> finalSellers = [];
    List<UserModel> nearbySellers = [];
    nearbySellers = await getAllUsers();
    for (var seller in nearbySellers) {
      LatLng locationLatLng =
          LatLng(placeLocation.latitude, placeLocation.longitude);
      LatLng sellerLatLng =
          LatLng(seller.location!.latitude, seller.location!.longitude);
      if (Constants.getDistance(locationLatLng, sellerLatLng) <=
          Constants.nearbySellerDistanceInKilometers) {
        finalSellers.add(seller);
      }
    }
    return finalSellers;
  }

  static Future<List<PlaceModel>> getNearbyPlaces(LatLng currentLatLng,
      {String? activePlaceID}) async {
    List<PlaceModel> nearbyPlaces = [];
    List<PlaceModel> places = await getAllPlaces();
    for (var place in places) {
      if (Constants.getDistance(currentLatLng,
              LatLng(place.location.latitude, place.location.longitude)) <=
          Constants.nearbyPlacesDistanceInKilometers) {
        if (!(activePlaceID != null && activePlaceID == place.id)) {
          nearbyPlaces.add(place);
        }
      }
    }
    return nearbyPlaces;
  }

  static Future<List<PlaceModel>> getAllPlaces() async {
    List<PlaceModel> places = [];
    await _firebaseFirestore
        .collectionGroup(Constants.placesCollection)
        .get()
        .then((value) {
      for (var element in value.docs) {
        places.add(PlaceModel.fromJson(element.data()));
      }
    });
    return places;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> isPlaceAlreadyLiked(
      String placeID) {
    return _firebaseFirestore
        .collectionGroup(Constants.wishListsCollection)
        .where("user_id", isEqualTo: _firebaseAuth.currentUser?.uid)
        .where("place_id", isEqualTo: placeID)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getStreamOfNotifications() {
    return _firebaseFirestore
        .collection(Constants.notificationsCollection)
        .where("user_id", isEqualTo: _firebaseAuth.currentUser?.uid)
        .orderBy("sent_at", descending: true)
        .snapshots();
  }

  static Future<void> markPlaceAsLiked(
      String placeID, BuildContext context) async {
    DocumentReference likedByReference = _firebaseFirestore
        .collection(Constants.placesCollection)
        .doc(placeID)
        .collection(Constants.wishListsCollection)
        .doc();
    LikedByModel likedByModel = LikedByModel(
      id: likedByReference.id,
      userId: _firebaseAuth.currentUser!.uid,
      placeId: placeID,
      createdAt: Timestamp.now(),
    );
    await likedByReference.set(likedByModel.toJson());
  }

  static Future<void> markPlaceAsUnLiked(
      String placeID, String likedDocID, BuildContext context) async {
    DocumentReference likedByReference = _firebaseFirestore
        .collection(Constants.placesCollection)
        .doc(placeID)
        .collection(Constants.wishListsCollection)
        .doc(likedDocID);
    await likedByReference.delete();
  }

  static Future<List<PlaceModel>> getLikedPlaces() async {
    List<PlaceModel> places = [];
    await _firebaseFirestore
        .collectionGroup(Constants.wishListsCollection)
        .where("user_id", isEqualTo: _firebaseAuth.currentUser?.uid)
        .orderBy("created_at")
        .get()
        .then((_likedBys) async {
      await Future.forEach(_likedBys.docs,
          (QueryDocumentSnapshot<Map<String, dynamic>> _likedBy) async {
        LikedByModel likedBy = LikedByModel.fromJson(_likedBy.data());
        PlaceModel place = await getPlaceByID(likedBy.placeId);
        places.add(place);
      });
    });
    return places;
  }

  static Future<PlaceModel> getPlaceByID(String placeID) async {
    PlaceModel? place;
    await _firebaseFirestore
        .collection(Constants.placesCollection)
        .where("id", isEqualTo: placeID)
        .get()
        .then((_places) {
      PlaceModel _place = PlaceModel.fromJson(_places.docs.first.data());
      place = _place;
    });
    return place!;
  }

  static Future<String> uploadSelectedImage(File _image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(Constants.usersCollection)
        .child(Constants.profilePictures)
        .child(_firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(_image);
    String imageURL = "";
    await uploadTask.then((value) async {
      imageURL = await value.ref.getDownloadURL();
    });
    return imageURL;
  }

  static updateProfileImageURL(String url) async {
    await _firebaseFirestore
        .collection(Constants.usersCollection)
        .doc(_firebaseAuth.currentUser?.uid)
        .update({"image_url": url});
    return;
  }

  static Future<List<ProductModel>> getProductsOfSeller(String sellerID) async {
    List<ProductModel> products = [];
    await _firebaseFirestore
        .collection(Constants.productsCollection)
        .where("seller", isEqualTo: sellerID)
        .where("is_allowed", isEqualTo: true)
        .orderBy("published_at", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        products.add(ProductModel.fromJson(element.data()));
      }
    });
    return products;
  }

  static Future<void> publishReview(
      String id, String feedback, double placeRating) async {
    DocumentReference reviewReference =
        _firebaseFirestore.collection(Constants.reviewsCollection).doc();
    ReviewModel review = ReviewModel(
      id: id,
      remarks: feedback,
      lastActivityAt: Timestamp.now(),
      rating: placeRating,
      placeId: id,
      userId: _firebaseAuth.currentUser!.uid,
    );
    await reviewReference.set(review.toJson());
  }

  static Future<List<ReviewModel>> getReviewsOfPlace(String id) async {
    List<ReviewModel> reviews = [];
    await _firebaseFirestore
        .collection(Constants.reviewsCollection)
        .where("place_id", isEqualTo: id)
        .orderBy("last_activity_at", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        reviews.add(ReviewModel.fromJson(element.data()));
      }
    });
    return reviews;
  }

  static Future<UserModel> getUserById(String userId) async {
    late UserModel user;
    await _firebaseFirestore
        .collection(Constants.usersCollection)
        .where("id", isEqualTo: userId)
        .orderBy("joined_at", descending: true)
        .get()
        .then((value) {
      user = UserModel.fromJson(value.docs.first.data());
    });
    return user;
  }

  static Future<void> updatePlaceRating(
      double finalRating, String placeID) async {
    await _firebaseFirestore
        .collection(Constants.placesCollection)
        .doc(placeID)
        .update({"rating": finalRating});
    return;
  }

  static Future<void> sendNotification(String title, String description,
      String sellerID, String imageURL) async {
    DocumentReference notificationReference =
        _firebaseFirestore.collection(Constants.notificationsCollection).doc();

    // adding both sender and receiver so both will have this in notification screen
    List<String> users = [];
    users.add(_firebaseAuth.currentUser!.uid);
    users.add(sellerID);

    NotificationModel notification = NotificationModel(
      id: notificationReference.id,
      title: title,
      description: description,
      sentAt: Timestamp.now(),
      userId: _firebaseAuth.currentUser!.uid,
      imageUrl: imageURL,
      users: users,
    );
    await notificationReference.set(notification.toJson());
  }

  static void signOut(BuildContext context) {
    _firebaseAuth.signOut();
    Constants.pushAndRemoveAll(
      context,
      const Login(),
    );
  }

  static bool checkEmailVerificationStatus() {
    return _firebaseAuth.currentUser!.emailVerified;
  }

  static Future<void> sendEmailVerificationLink() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  static Future<bool> checkIfNotTourist() async {
    UserModel user = await getLoggedInUser();
    if (user.roles.contains("tourist")) {
      return false;
    } else {
      return true;
    }
  }
}

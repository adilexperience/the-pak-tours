import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  ReviewModel({
    required this.id,
    required this.remarks,
    required this.placeId,
    required this.userId,
    required this.rating,
    required this.lastActivityAt,
  });

  String id;
  String remarks;
  String placeId;
  String userId;
  double rating;
  Timestamp lastActivityAt;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        remarks: json["remarks"],
        placeId: json["place_id"],
        userId: json["user_id"],
        rating: json["rating"],
        lastActivityAt: json["last_activity_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "remarks": remarks,
        "place_id": placeId,
        "user_id": userId,
        "rating": rating,
        "last_activity_at": lastActivityAt,
      };
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

LikedByModel likedByModelFromJson(String str) =>
    LikedByModel.fromJson(json.decode(str));

String likedByModelToJson(LikedByModel data) => json.encode(data.toJson());

class LikedByModel {
  LikedByModel({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String placeId;
  final Timestamp createdAt;

  factory LikedByModel.fromJson(Map<String, dynamic> json) => LikedByModel(
        id: json["id"],
        userId: json["user_id"],
        placeId: json["place_id"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "place_id": placeId,
        "created_at": createdAt,
      };
}

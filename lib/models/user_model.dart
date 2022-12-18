import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.emailAddress,
    required this.roles,
    required this.joinedAt,
    required this.isAllowed,
    required this.imageUrl,
    this.location,
  });

  final String id;
  final String name;
  final String emailAddress;
  final List<String> roles;
  final Timestamp joinedAt;
  final bool isAllowed;
  final String imageUrl;
  final GeoPoint? location;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        emailAddress: json["email_address"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        joinedAt: json["joined_at"],
        isAllowed: json["is_allowed"],
        imageUrl: json["image_url"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email_address": emailAddress,
        "roles": List<String>.from(roles.map((x) => x)),
        "joined_at": joinedAt,
        "is_allowed": isAllowed,
        "image_url": imageUrl,
        "location": location,
      };
}

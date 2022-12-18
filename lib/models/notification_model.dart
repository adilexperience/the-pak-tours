// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.sentAt,
    required this.userId,
    required this.imageUrl,
    required this.users,
  });

  String id;
  String title;
  String description;
  Timestamp sentAt;
  String userId;
  String imageUrl;
  List<String> users;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        sentAt: json["sent_at"],
        userId: json["user_id"],
        imageUrl: json["image_url"],
        users: List<String>.from(json["users"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "sent_at": sentAt,
        "user_id": userId,
        "image_url": imageUrl,
        "users": List<dynamic>.from(users.map((x) => x)),
      };
}

// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.seller,
    required this.isAllowed,
    required this.publishedAt,
  });

  String id;
  String title;
  String description;
  String price;
  String image;
  String seller;
  bool isAllowed;
  Timestamp publishedAt;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        price: json["price"],
        seller: json["seller"],
        isAllowed: json["is_allowed"],
        publishedAt: json["published_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "price": price,
        "seller": seller,
        "is_allowed": isAllowed,
        "published_at": publishedAt,
      };
}

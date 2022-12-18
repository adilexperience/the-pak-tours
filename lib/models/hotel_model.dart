// To parse this JSON data, do
//
//     final hotelModel = hotelModelFromJson(jsonString);

import 'dart:convert';

HotelModel hotelModelFromJson(String str) =>
    HotelModel.fromJson(json.decode(str));

String hotelModelToJson(HotelModel data) => json.encode(data.toJson());

class HotelModel {
  HotelModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.address,
  });

  String id;
  String title;
  String image;
  String description;
  String price;
  String address;

  factory HotelModel.fromJson(Map<String, dynamic> json) => HotelModel(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        description: json["description"],
        price: json["price"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "description": description,
        "price": price,
        "address": address,
      };
}

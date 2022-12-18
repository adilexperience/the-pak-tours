import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_pak_tours/models/models_exporter.dart';

PlaceModel placeModelFromJson(String str) =>
    PlaceModel.fromJson(json.decode(str));

String placeModelToJson(PlaceModel data) => json.encode(data.toJson());

class PlaceModel {
  PlaceModel({
    required this.description,
    required this.history,
    required this.id,
    required this.images,
    required this.location,
    required this.rating,
    required this.title,
    required this.hotels,
    required this.type,
  });

  String description;
  String history;
  String id;
  List<String> images;
  GeoPoint location;
  double rating;
  List<HotelModel> hotels;
  String title;
  String type;

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        description: json["description"],
        history: json["history"],
        id: json["id"],
        images: List<String>.from(json["images"].map((x) => x)),
        location: json["location"],
        rating: json["rating"].toDouble(),
        title: json["title"],
        hotels: List<HotelModel>.from(
            json["hotels"].map((x) => HotelModel.fromJson(x))),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "history": history,
        "id": id,
        "images": List<String>.from(images.map((x) => x)),
        "location": location,
        "rating": rating,
        "title": title,
        "type": type,
        "hotels": List<HotelModel>.from(hotels.map((x) => x.toJson())),
      };
}

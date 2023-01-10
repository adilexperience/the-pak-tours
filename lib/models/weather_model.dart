// To parse this JSON data, do
//
//     final weatherModel = weatherModelFromJson(jsonString);

import 'dart:convert';

WeatherModel? weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));

String weatherModelToJson(WeatherModel? data) => json.encode(data!.toJson());

class WeatherModel {
  WeatherModel({
    required this.list,
    required this.city,
  });

  final List<ListElement?>? list;
  final City? city;

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        list: json["list"] == null
            ? []
            : List<ListElement?>.from(
                json["list"]!.map((x) => ListElement.fromJson(x))),
        city: City.fromJson(json["city"]),
      );

  Map<String, dynamic> toJson() => {
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x!.toJson())),
        "city": city!.toJson(),
      };
}

class City {
  City({
    required this.name,
    required this.population,
    required this.sunrise,
    required this.sunset,
  });

  final String? name;
  final int? population;
  final int? sunrise;
  final int? sunset;

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
        population: json["population"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "population": population,
        "sunrise": sunrise,
        "sunset": sunset,
      };
}

class ListElement {
  ListElement({
    required this.main,
    required this.weather,
    required this.dtTxt,
  });

  final Main? main;
  final List<Weather?>? weather;
  final DateTime? dtTxt;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        main: Main.fromJson(json["main"]),
        weather: json["weather"] == null
            ? []
            : List<Weather?>.from(
                json["weather"]!.map((x) => Weather.fromJson(x))),
        dtTxt: DateTime.parse(json["dt_txt"]),
      );

  Map<String, dynamic> toJson() => {
        "main": main!.toJson(),
        "weather": weather == null
            ? []
            : List<dynamic>.from(weather!.map((x) => x!.toJson())),
        "dt_txt": dtTxt?.toIso8601String(),
      };
}

class Main {
  Main({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
  });

  final double? temp;
  final double? tempMin;
  final double? tempMax;

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: json["temp"].toDouble(),
        tempMin: json["temp_min"].toDouble(),
        tempMax: json["temp_max"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "temp": temp,
        "temp_min": tempMin,
        "temp_max": tempMax,
      };
}

class Weather {
  Weather({
    required this.id,
    required this.main,
    required this.icon,
  });

  final int? id;
  final String? main;
  final String? icon;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json["id"],
        main: json["main"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main": main,
        "icon": icon,
      };
}

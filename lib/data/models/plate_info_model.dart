import 'package:flutter/material.dart';

class PlateInfo{
  String? type;
  String plate;
  String? year;
  String? description;
  String? brand;
  String? color;

  PlateInfo({
    required this.type, 
    required this.plate, 
    required this.year, 
    required this.description,
    required this.brand, 
    required this.color
  });

  factory PlateInfo.fromJson(Map json){
    print(json);
    return PlateInfo(
      type: json["type"],
      plate: json["plate"],
      year: json["year"],
      description: json["description"],
      brand: json["brand"],
      color: json["color"]
    );
  }

  factory PlateInfo.unknown(String plate){
    return PlateInfo(
      type: null, 
      plate: plate, 
      year: null, 
      description: null, 
      brand: null, 
      color: null
    );
  }

  Map toJson(){
    return {
      'type': type,
      'plate': plate,
      'year': year,
      'description': description,
      'brand': brand,
      'color': color
    };
  }
}
import 'dart:convert';

import 'package:sjekk_application/core/utils/logger.dart';
import 'package:sjekk_application/data/models/car_image_model.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/data/models/rule_model.dart';
import 'package:sjekk_application/data/models/user_model.dart';

class Violation{
  User user;
  List<Rule> rules;
  String status;
  String createdAt;
  String? completedAt;
  dynamic id;
  bool is_car_registered;
  PlateInfo plateInfo;
  RegisteredCar? registeredCar;
  Place place;
  List<CarImage> carImages;
  String paperComment;
  String outComment;
  String? printPaper;
  String? ticketNumber;
  String? placeStartTime;

  Violation({
    required this.rules,
    required this.status, 
    required this.createdAt, 
    this.id,
    this.printPaper,
    this.ticketNumber,
    this.placeStartTime,
    required this.plateInfo,
    required this.carImages,
    required this.place,
    required this.paperComment,
    required this.outComment,
    required this.is_car_registered,
    required this.registeredCar,
    required this.completedAt,
    required this.user
  });

  factory Violation.fromJson(Map data){
    pinfo(data['publisher_identifier']);
    Violation violation = Violation(
      rules: (data['rules'] as List<dynamic>).map((e){
        return Rule.fromJson(e);
      }).toList(),
      status: data['status'],
      createdAt: data['created_at'],
      completedAt: data['completed_at'],
      id: data['_id'],
      user: User.fromTicket(data['publisher_identifier']),
      plateInfo: PlateInfo.fromJson(data['plate_info']),
      carImages: (data['images'] as List<dynamic>).map((e){
        return CarImage.fromJson(e);
      }).toList(),
      place: Place.fromJson(data['place']),
      paperComment: data['paper_comment'],
      outComment: data['out_comment'],
      printPaper: data['print_paper'],
      ticketNumber: data['ticket_number'],
      is_car_registered: data['is_car_registered'],
      registeredCar: data['registered_car_info'] != null ? RegisteredCar.fromJson(data['registered_car_info']) : null,
    );
  print(violation);
    return violation;
  }

    factory Violation.fromEncodedJson(Map data){
      pinfo(data);
      pinfo(data['publisher_identifier']);

    Violation violation = Violation(
      rules: (jsonDecode(data['rules']) as List<dynamic>).map((e){
        return Rule.fromJson(e);
      }).toList(),
      status: data['status'],
      user: User.fromTicket(
        jsonDecode(data['publisher_identifier'])
      ),
      createdAt: data['created_at'],
      completedAt: data['completed_at'],
      id: data['id'],
      plateInfo: PlateInfo.fromJson(jsonDecode(data['plate_info'])),
      carImages: (jsonDecode(data['car_images']) as List<dynamic>).map((e){
        return CarImage.fromJson(e);
      }).toList(),
      ticketNumber: data['ticket_number'],
      printPaper: data['print_paper'],
      place: Place.fromJson(jsonDecode(data['place'])),
      paperComment: data['paper_comment'],
      outComment: data['out_comment'],
      placeStartTime: data['place_start_time'],
      is_car_registered: jsonDecode(data['is_car_registered']) > 0,
      registeredCar: jsonDecode(data['registered_car_info']) != null ? RegisteredCar.fromJson(jsonDecode(data['registered_car_info'])) : null,
    );
  print(violation);
    return violation;
  }

  Map<String,dynamic> toJson(){
    return {
       'rules': rules,
       'status': status,
       'created_at': createdAt,
       'plate_info': plateInfo,
       'place': place.toJson(),
       'car_images': carImages.map((e) => e.toJson()),
       'paper_comment': paperComment,
       'out_comment': outComment,
       'is_car_registered': is_car_registered,
    };
  }

  Map<String,dynamic> toJsonEncoded(){
    return {
       'rules': jsonEncode(rules),
       'status': status,
       'created_at': createdAt,
       'plate_info': jsonEncode(plateInfo.toJson()),
       'publisher_identifier': jsonEncode(user.toJson()),
       'place': jsonEncode(place.toJson()),
       'car_images': jsonEncode(carImages),
       'paper_comment': paperComment,
       'out_comment': outComment,
       'is_car_registered': is_car_registered,
       'registered_car_info': jsonEncode(registeredCar),
       'place_start_time': placeStartTime
    };
  }

  Violation copyWithNewDate({
    String? newCreatedAt,
    String? newPlaceLoginTime
  }) {
    return Violation(
      rules: rules,
      status: status,
      createdAt: newCreatedAt ?? createdAt,
      placeStartTime: newPlaceLoginTime ?? placeStartTime,
      completedAt: completedAt,
      id: id,
      printPaper: printPaper,
      plateInfo: plateInfo,
      carImages: carImages,
      place: place,
      paperComment: paperComment,
      outComment: outComment,
      is_car_registered: is_car_registered,
      registeredCar: registeredCar,
      user: user,
    );
  }
}


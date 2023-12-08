import 'package:sjekk_application/data/models/place_model.dart';

class RegisteredCar{
  final String boardNumber;
  // final String id;
  final String registerationType;
  final String rank;
  final String startDate;
  final String endDate;
  final String createdAt;
  // final Place place;

  RegisteredCar({
    required this.boardNumber,
    required this.registerationType, 
    required this.startDate, 
    required this.endDate,
    required this.createdAt,
    required this.rank
    // required this.place,
    // required this.id
  });

  factory RegisteredCar.fromJson(Map json){
    return RegisteredCar(
      boardNumber: json["plate_number"],
      registerationType: json["registeration_type"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      createdAt: json["created_at"],
      rank: json["rank"]
      // id: json['_id'],
      // place: Place.fromJson(json['place'])
    );
  }

  Map toJson(){
    return {
      'plate_number': boardNumber,
      'registeration_type': registerationType,
      'start_date': startDate,
      'end_date': endDate,
      'created_at': createdAt,
      'rank': rank,
    };
  }
}
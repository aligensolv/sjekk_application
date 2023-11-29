import 'package:sjekk_application/data/models/car_image_model.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/data/models/rule_model.dart';

class Violation{
  final List<Rule> rules;
  final String status;
  final String createdAt;
  final String? completedAt;
  final String id;
  final bool is_car_registered;
  final PlateInfo plateInfo;
  final RegisteredCar? registeredCar;
  final Place place;
  final List<CarImage> carImages;
  String paperComment;
  String outComment;

  Violation({
    required this.rules,
    required this.status, 
    required this.createdAt, 
    required this.id,
    required this.plateInfo,
    required this.carImages,
    required this.place,
    required this.paperComment,
    required this.outComment,
    required this.is_car_registered,
    required this.registeredCar,
    required this.completedAt
  });

  factory Violation.fromJson(Map data){
      print(data['status']);
      print(data['created_at']);
      print(data['_id']);
    Violation violation = Violation(
      rules: (data['rules'] as List<dynamic>).map((e){
        return Rule.fromJson(e);
      }).toList(),
      status: data['status'],
      createdAt: data['created_at'],
      completedAt: data['completed_at'],
      id: data['_id'],
      plateInfo: PlateInfo.fromJson(data['plate_info']),
      carImages: (data['images'] as List<dynamic>).map((e){
        return CarImage.fromString(e);
      }).toList(),
      place: Place.fromJson(data['place']),
      paperComment: data['paper_comment'],
      outComment: data['out_comment'],
      is_car_registered: data['is_car_registered'],
      registeredCar: data['registered_car_info'] != null ? RegisteredCar.fromJson(data['registered_car_info']) : null,
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
       'is_car_registered': is_car_registered
    };
  }
}
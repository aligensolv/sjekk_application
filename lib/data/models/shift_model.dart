import 'place_login_model.dart';

class Shift{
  final String id;
  final String startDate;
  final List<PlaceLogin> logins;

  Shift({required this.id, required this.startDate, required this.logins});

  factory Shift.fromJson(Map json){
    return Shift(
      id: json["_id"],
      startDate: json["start_date"],
      logins: (json['logins'] as List).map((e){
        return PlaceLogin.fromJson(e);
      }).toList()
    );
  }
}
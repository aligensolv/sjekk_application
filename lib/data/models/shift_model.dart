class Shift{
  final String id;
  final String startDate;

  Shift({required this.id, required this.startDate});

  factory Shift.fromJson(Map json){
    return Shift(
      id: json["_id"],
      startDate: json["start_date"]
    );
  }
}
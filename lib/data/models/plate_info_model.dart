class PlateInfo{
  final String type;
  final String plate;
  final String year;
  final String description;
  final String brand;

  PlateInfo({required this.type, required this.plate, required this.year, required this.description, required this.brand});

  factory PlateInfo.fromJson(Map json){
    print(json);
    return PlateInfo(
      type: json["type"],
      plate: json["plate"],
      year: json["year"],
      description: json["description"],
      brand: json["brand"]
    );
  }

  Map toJson(){
    return {
      'type': type,
      'plate': plate,
      'year': year,
      'description': description,
      'brand': brand
    };
  }
}
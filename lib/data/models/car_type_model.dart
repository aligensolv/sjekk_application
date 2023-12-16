class CarType{
  final String value;

  CarType({required this.value});

  factory CarType.fromJson(Map data){
    return CarType(
      value: data['value'],
    );
  }
}
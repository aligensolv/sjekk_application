class CarColor{
  final String value;

  CarColor({required this.value});

  factory CarColor.fromJson(Map data){
    return CarColor(
      value: data['value'],
    );
  }
}
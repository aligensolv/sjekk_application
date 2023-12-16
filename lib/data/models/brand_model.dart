class Brand{
  final String value;

  Brand({required this.value});

  factory Brand.fromJson(Map data){
    return Brand(
      value: data['value']
    );
  }
}
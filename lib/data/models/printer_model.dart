class Printer{
  final String name;
  final String address;
  int? id;

  Printer({required this.name, required this.address, this.id});

  factory Printer.fromJson(Map data){
    return Printer(
      name: data["name"],
      address: data["address"],
      id: data["id"]
    );
  }

  Map<String, String> toJson(){
    return {
      'name': name,
      'address': address,
    };
  }
}
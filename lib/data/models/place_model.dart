class Place{
  final String id;
  final String location;
  final String policy;
  final String code;

  Place({required this.location, required this.policy, required this.id, required this.code});

  factory Place.fromJson(Map data){
    print(data);
    return Place(
        location: data['location'],
        policy: data['policy'],
        id: data['_id'],       
        code: data['code']
    );
  }

  Map toJson(){
    return {
      'location': location,
      'policy': policy,
      '_id': id,
    };
  }
}
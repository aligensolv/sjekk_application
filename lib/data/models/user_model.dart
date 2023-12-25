class User {
  final String? username;
  final String? identifier;

  String? token;

  User({required this.identifier, required this.username, this.token});

  factory User.fromJson(Map json){
    return User(
      identifier: json['user']['user_identifier'],
      username: json['user']['name'],
      token: json['token'],
    );
  }

  factory User.fromTicket(Map json){
    return User(
      identifier: json['user_identifier'],
      username: json['name'],
    );
  }

  Map<String,String> toJson(){
    return {
      'identifier': identifier ?? '',
      'username': username ?? '',
      'token': token ?? '',
    };
  }
}

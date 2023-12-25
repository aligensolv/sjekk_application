class PlaceLogin{
  final String placeName;
  final String placeId;
  final String loginTime;
  final String logoutTime;

  PlaceLogin({required this.placeName, required this.loginTime, required this.logoutTime, required this.placeId});

  factory PlaceLogin.fromJson(Map data){
    return PlaceLogin(
      placeName: data['place_name'],
      loginTime: data['login_time'],
      logoutTime: data['logout_time'],
      placeId: data['place_id'],
    );
  }

  Map toJson(){
    return {
      'place_name': placeName,
      'login_time': loginTime,
      'place_id': placeId,
      'logout_time': logoutTime
    };
  }
}
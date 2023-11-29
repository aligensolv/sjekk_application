import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/screens/login_screen.dart';
import '../../presentation/screens/unknown_route_screen.dart';


class LoginRouter{
  static Route<dynamic> generatedRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      default:
        return MaterialPageRoute(builder: (context) => UnknownRouteScreen());
    }
  }
}
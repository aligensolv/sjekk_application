import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/presentation/wrappers/connectivity_wrapper.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  _SplashScreenState(){

    Timer(
      const Duration(milliseconds: 10),(){
        setState(() {
          _isVisible = true;
        });
      }
    );

    Timer(const Duration(milliseconds: 2000), (){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ConnectivityWrapper())
      );
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.gensolv),
                fit: BoxFit.cover,
                  alignment: FractionalOffset(.25, 0.5)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
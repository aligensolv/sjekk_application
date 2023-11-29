import 'dart:async';

import 'package:flutter/material.dart';

class PolicyTimeProvider extends ChangeNotifier{
  DateTime currentTime = DateTime.now();

  Stream timer() async*{
    Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime.add(Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
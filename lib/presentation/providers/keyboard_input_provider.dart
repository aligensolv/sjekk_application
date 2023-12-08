import 'package:flutter/material.dart';

enum KeyboardMode {
  letters,
  digits
}

class KeyboardInputProvider extends ChangeNotifier{
  String plate = '';
  KeyboardMode mode = KeyboardMode.letters;


  void changeMode(KeyboardMode newMode){
    mode = newMode;
    notifyListeners();
  }

  updatePlate(String input){
    plate += input;

    if(plate.length == 2 && mode == KeyboardMode.letters){
      mode = KeyboardMode.digits;
    }

    notifyListeners();
  }

  rollback(){
    if(plate.isNotEmpty){
      plate = plate.substring(0, plate.length - 1);

      if(plate.length < 3 && mode == KeyboardMode.digits){
        mode = KeyboardMode.letters;
      }

      notifyListeners();
    }
  }

  clearPlate(){
    plate = "";
    mode = KeyboardMode.letters;
    notifyListeners();
  }


  @override
  void dispose() {
    clearPlate();
    super.dispose();
  }
}
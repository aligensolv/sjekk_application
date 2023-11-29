import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/car_image_model.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/data/repositories/remote/violation_repository.dart';

import '../../data/models/print_option_model.dart';
import '../../data/models/rule_model.dart';

class ViolationDetailsProvider extends ChangeNotifier{
  late Violation violation;

  bool errorState = false;
  String errorMessage = "";

  List<PrintOption> printOptions = [
    PrintOption(name: 'Print now', type: PrintType.now),
    PrintOption(name: 'Send with post', type: PrintType.post),
    PrintOption(name: 'Give to hand', type: PrintType.hand)
  ];

  int selectedPrintOptionIndex = 0;

  ViolationRepositoryImpl _violationRepositoryImpl = ViolationRepositoryImpl();

  clear(){
    errorState = false;
    errorMessage = "";
  }

  setSelectedPrintOptionIndex(int newIndex){
    selectedPrintOptionIndex = newIndex;
    notifyListeners();
  }

  setViolation(Violation violation_value){
    violation = violation_value;
    notifyListeners();
  }

  Future addImage(String path) async{
    try{
      final String imageSource = await _violationRepositoryImpl.addImage(violation.id, path);
      CarImage carImage = CarImage.fromString(imageSource);
      violation.carImages.add(carImage);
      clear();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }

    notifyListeners();
  }

    Future addRule(String id) async{
    try{
      final Rule rule = await _violationRepositoryImpl.addRule(violation.id, id);
      violation.rules.add(rule);
      clear();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }

    notifyListeners();
  }

  Future saveInnerComment(String innerComment) async{
    try{
      String response = await _violationRepositoryImpl.updateInnerComment(violation.id, innerComment);
      violation.paperComment = response;
      clear();
      notifyListeners();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }
  }

  Future saveOutterComment(String outterComment) async{
    try{
      String response = await _violationRepositoryImpl.updateOutterComment(violation.id, outterComment);
      violation.outComment = response;
      clear();
      notifyListeners();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }
  }
}
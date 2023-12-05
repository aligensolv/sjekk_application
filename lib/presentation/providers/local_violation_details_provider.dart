import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/car_image_model.dart';
import 'package:sjekk_application/data/models/rule_model.dart';

import '../../data/models/print_option_model.dart';
import '../../data/models/violation_model.dart';

class LocalViolationDetailsProvider extends ChangeNotifier{
  late Violation localViolationCopy;
  
  List<PrintOption> printOptions = [
    PrintOption(name: 'Print now', type: PrintType.now),
    PrintOption(name: 'Send with post', type: PrintType.post),
    PrintOption(name: 'Give to hand', type: PrintType.hand)
  ];

  int selectedPrintOptionIndex = 0;

  setSelectedPrintOptionIndex(int newIndex){
    selectedPrintOptionIndex = newIndex;
    notifyListeners();
  }

  storeLocalViolationCopy(Violation copy){
    localViolationCopy = copy;
    notifyListeners();
  }

  pushImage(String path){
    CarImage carImage = CarImage.fromString(path);
    localViolationCopy.carImages.add(carImage);
    notifyListeners();
  }

  pushRule(Rule rule){
    localViolationCopy.rules.add(rule);
    notifyListeners();
  }

  updateInnerComment(String comment){
    localViolationCopy.paperComment = comment;
    notifyListeners();
  }

  updateOutterComment(String comment){
    localViolationCopy.outComment = comment;
    notifyListeners();
  }
}
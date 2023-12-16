import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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

  Timer? printTimer;
  int maxTimePolicy = 0;
  String timePassed = "";
  bool isTimerActive = false;

  updateTimePolicy(){
    if(localViolationCopy.rules.any((element) => element.policyTime > 0)){
      print('yes bigger on found');
      int newMaxTimePolicy = localViolationCopy.rules.map((e) => e.policyTime).reduce(max);

      print('max is $newMaxTimePolicy');

      if(newMaxTimePolicy > maxTimePolicy){
        maxTimePolicy = newMaxTimePolicy;
        if(printTimer == null || !(printTimer?.isActive ?? false)){
          createPrintTimer();
        }

        notifyListeners();
      }
    }
  }

  createPrintTimer(){
    isTimerActive = true;
    notifyListeners();

    printTimer = Timer.periodic(
      Duration(seconds: 1), 
      (timer) {
        DateTime parsedCreatedAt = DateTime.parse(localViolationCopy.createdAt);
        if(DateTime.now().difference(parsedCreatedAt).inMinutes <= maxTimePolicy){
          timePassed = DateFormat('mm:ss')
          .format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().difference(parsedCreatedAt).inMilliseconds));

          notifyListeners();
        }else{
          cancelPrintTimer();
        }
      }
    );
  }

  cancelPrintTimer(){
    isTimerActive = false;
    timePassed = "";
    maxTimePolicy = 0;
    printTimer?.cancel();
    notifyListeners();
  }

  @override
  dispose(){
    cancelPrintTimer();
    super.dispose();
  }

  setSelectedPrintOptionIndex(int newIndex){
    selectedPrintOptionIndex = newIndex;
    notifyListeners();
  }

  storeLocalViolationCopy(Violation copy){
    localViolationCopy = copy;
    notifyListeners();
  }

  pushImage(String path) async {
    final String localPath = (await getApplicationDocumentsDirectory()).path;


    final File _file = File(path);
    String cachedPath = '$localPath/${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(176676767)}.png';
    await _file.copy(cachedPath);

    CarImage carImage = CarImage.fromString(cachedPath);
    int id = Random().nextInt(9999990);
    carImage.id = id;

    localViolationCopy.carImages.add(carImage);
    notifyListeners();
  }

  removeImage(int? id){
    localViolationCopy.carImages = localViolationCopy.carImages.where((element){
      return element.id != id;
    }).toList();

    notifyListeners();
  }

  pushRule(Rule rule){
    localViolationCopy.rules.add(rule);
    localViolationCopy.rules.sort(
      (a, b){
            var partsA = a.name.split('-');
            var numberA = int.parse(partsA[0]);
            var partsB = b.name.split('-');
            var numberB = int.parse(partsB[0]);

            return numberA - numberB;
      }
  );
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
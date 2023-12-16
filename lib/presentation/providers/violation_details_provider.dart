import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sjekk_application/core/utils/logger.dart';
import 'package:sjekk_application/data/models/brand_model.dart';
import 'package:sjekk_application/data/models/car_image_model.dart';
import 'package:sjekk_application/data/models/car_type_model.dart';
import 'package:sjekk_application/data/models/color_model.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/data/repositories/remote/violation_repository.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';

import '../../data/models/print_option_model.dart';
import '../../data/models/rule_model.dart';
import 'dart:math';

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

  Timer? printTimer;
  int maxTimePolicy = 0;
  String timePassed = "";
  bool isTimerActive = false;

  DateTime? siteLoginTime;

  setSiteLoginTime(DateTime? date){
    siteLoginTime = date;
    notifyListeners();
  }

  updateTimePolicy(){
    if(violation.rules.isEmpty){
      return;
    }

    Rule rule = violation.rules.first;


    if(rule.policyTime == 0){
      return;
    }

    maxTimePolicy = rule.policyTime;
    if(printTimer == null || !(printTimer?.isActive ?? false)){
      createPrintTimer();
    }

    notifyListeners();

    // if(violation.rules.any((element) => element.policyTime > 0)){
    //   print('yes bigger on found');
    //   int newMaxTimePolicy = violation.rules.map((e) => e.policyTime).reduce(max);

    //   print('max is $newMaxTimePolicy');

    //   if(newMaxTimePolicy > maxTimePolicy){
    //     maxTimePolicy = newMaxTimePolicy;
    //     if(printTimer == null || !(printTimer?.isActive ?? false)){
    //       createPrintTimer();
    //     }

    //     notifyListeners();
    //   }
    // }
  }

  createPrintTimer(){
    isTimerActive = true;
    notifyListeners();


    printTimer = Timer.periodic(
      Duration(seconds: 1), 
      (timer) {
        // DateTime parsedCreatedAt = DateTime.parse(violation.createdAt);
        DateTime parsedCreatedAt = siteLoginTime ?? DateTime.now();
        perror(parsedCreatedAt);
        pinfo(
          DateTime.now().difference(parsedCreatedAt).inMinutes
        );
        if(
          DateTime.now().difference(parsedCreatedAt).inMinutes < maxTimePolicy
          || DateTime.now().difference(parsedCreatedAt).inMinutes < 6  
        ){
          timePassed = DateFormat('mm:ss')
          .format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().difference(parsedCreatedAt).inMilliseconds));
          notifyListeners();
        }else{
          pinfo(',mmm in elses ????/?');
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
    siteLoginTime = null;
    notifyListeners();
  }

  @override
  dispose(){
    cancelPrintTimer();
    clear();
    super.dispose();
  }

  final ViolationRepositoryImpl _violationRepositoryImpl = ViolationRepositoryImpl();

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


  Future uploadImage(String path) async{
    ViolationRepositoryImpl impl = ViolationRepositoryImpl();
    String image = await impl.uploadImage(violation.id,path);
    violation.carImages.add(
      CarImage.fromString(image)
    );

    notifyListeners();
  }

  Future uploadViolationToServer() async{
    try{
      await _violationRepositoryImpl.uploadViolationToServer(violation);
      clear();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }

    notifyListeners();
  }

  Future changeViolationType(CarType type) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.plateInfo.type = type.value;

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'plate_info': jsonEncode(_violation.plateInfo.toJson())
    });

    violation.plateInfo.type = type.value;
    notifyListeners();
  }

  Future changeViolationBrand(Brand brand) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.plateInfo.brand = brand.value;

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'plate_info': jsonEncode(_violation.plateInfo.toJson())
    });

    violation.plateInfo.brand = brand.value;
    notifyListeners();
  }

  Future changeViolationColor(CarColor color) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.plateInfo.color = color.value;

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'plate_info': jsonEncode(_violation.plateInfo.toJson())
    });

    violation.plateInfo.color = color.value;
    notifyListeners();
  }

  Future changeViolationYear(String year) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.plateInfo.year = year;

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'plate_info': jsonEncode(_violation.plateInfo.toJson())
    });

    violation.plateInfo.year = year;
    notifyListeners();
  }

  Future changeViolationDescription(String description) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.plateInfo.description = description;

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'plate_info': jsonEncode(_violation.plateInfo.toJson())
    });

    violation.plateInfo.description = description;
    notifyListeners();
  }

  Future attachRuleToViolation(Rule rule) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.rules.add(rule);

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'rules': jsonEncode(
        _violation.rules.map((e) => e.toJson()).toList()
      )
    });

    violation.rules.add(rule);
    if(violation.rules.length == 1){
      updateTimePolicy();
    }
    notifyListeners();
  }

  Future deattachRuleToViolation(Rule rule) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.rules = _violation.rules.where((element){
      return element.id != rule.id;
    }).toList();


    await _violationRepositoryImpl.updateViolation(violation.id,{
      'rules': jsonEncode(
        _violation.rules.map((e) => e.toJson()).toList()
      )
    });

    violation.rules = _violation.rules;

    if(violation.rules.isEmpty){
      cancelPrintTimer();
    }
    notifyListeners();
  }

  Future changePaperComment(String comment) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.paperComment = comment;

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'paper_comment': comment 
    });

    violation.paperComment = comment;
    notifyListeners();
  }
  Future changeOutComment(String comment) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.outComment = comment;

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'out_comment': comment
    });

    violation.outComment = comment;
    notifyListeners();
  }

  Future removeImage(CarImage carImage) async{
    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.carImages = _violation.carImages.where((element){
      return element.id != carImage.id;
    }).toList();

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'car_images': jsonEncode(_violation.carImages)
    });

    violation.carImages = violation.carImages.where((element){
      return element.id != carImage.id;
    }).toList();
    notifyListeners();
  }

  Future storeImage(String path) async{
    final String localPath = (await getApplicationDocumentsDirectory()).path;


    final File _file = File(path);
    String cachedPath = '$localPath/${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(176676767)}.png';
    await _file.copy(cachedPath);
    CarImage carImage = CarImage.fromString(cachedPath);
    carImage.id = Random().nextInt(999999);

    Violation _violation = await _violationRepositoryImpl.getViolation(violation.id);
    _violation.carImages.add(
        carImage
    );

    await _violationRepositoryImpl.updateViolation(violation.id,{
      'car_images': jsonEncode(_violation.carImages)
    });

    violation.carImages.add(
      carImage
    );
    notifyListeners();
  }

  Future changePlateInfo(PlateInfo plateInfo) async{
      await _violationRepositoryImpl.updateViolation(violation.id,{
      'plate_info': jsonEncode(plateInfo)
    });

    violation.plateInfo = plateInfo;

    notifyListeners();
  }

  Future changeRegisterdCarData(RegisteredCar? registeredCar) async{
    
      await _violationRepositoryImpl.updateViolation(violation.id,{
      'is_car_registered': registeredCar != null,
      'registered_car_info': jsonEncode(registeredCar)
    });

    violation.registeredCar = registeredCar;
    violation.is_car_registered = registeredCar != null;

    notifyListeners();
  }
}
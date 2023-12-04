import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/data/models/print_option_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/data/models/rule_model.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/data/repositories/remote/car_repository_impl.dart';
import 'package:sjekk_application/data/repositories/remote/violation_repository.dart';
import 'package:sjekk_application/presentation/screens/saved_violations_screen.dart';

import '../../data/models/car_image_model.dart';
import '../../data/repositories/remote/autosys_repository_impl.dart';



class CreateViolationProvider extends ChangeNotifier{
  List<CarImage> carImages = [];
  List<Rule> rules = [];
  String paper_comment = "";
  String out_comment = "";


  int selectedPrintOptionIndex = 0;

  PlateInfo? plateInfo;
  RegisteredCar? registeredCar;
  bool isRegistered = false;

  bool errorState = false;
  String errorMessage = "";

  clearErrors(){
    errorState = false;
    errorMessage = "";
  }


  clearAll(){
    carImages.clear();
    rules.clear();
    paper_comment = '';
    out_comment = '';
    selectedPrintOptionIndex = 0;
    isRegistered = false;
    plateInfo = null;
    registeredCar = null;

    notifyListeners();
  }

  final _violationRepository = ViolationRepositoryImpl();
  Future<Violation?> saveViolation(BuildContext context) async{
    try{
      Violation violation = await _violationRepository.saveViolation(context);
      clearAll();
      return violation;
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
      return null;
    }
  }

  Future completeViolation(Violation violation) async{
    try{
      await _violationRepository.completeViolation(violation);
    }catch(error){
      return;
    }
  }

  Future deleteViolation(Violation violation) async{
    try{
      await _violationRepository.deleteViolation(violation);
      clearErrors();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }
  }

  Future<bool> createViolation(BuildContext context) async{
    try{
      await _violationRepository.createViolation(context);
      clearAll();
      return true;
    }catch(error){
      return false;
    }
  }

  Future<void> getSystemCar(String plate) async{
    try{
      final CarRepositoryImpl carRepository = CarRepositoryImpl();
      registeredCar = await carRepository.getCarByPlate(plate);
      isRegistered = true;
    }catch(error) {
      isRegistered = false;
    }

          notifyListeners();

  }
  Future<bool> getCarInfo(String plate) async{
    try{
      final AutosysRepositoryImpl autosysRepository = AutosysRepositoryImpl();

      PlateInfo _plateInfo = await autosysRepository.getCarInfo(plate);
      setCarInfo(_plateInfo);
      return true;
    }catch(error){
      print(error.toString());
      isRegistered = false;
      return false;
    }
  }

  updateSelectedPrintOptionIndex(index){
    selectedPrintOptionIndex = index;
    notifyListeners();
  }

  addRule(Rule rule){
    if(!rules.any((element) => element.id == rule.id)){
      rules.add(rule);
    }
  }

  removeRule(Rule rule){
    rules = rules.where((element) => element.id != rule.id).toList();
  }

  addImage(CarImage image){
    carImages.add(image);
    notifyListeners();
  }

  setPaperComment(String input){
    paper_comment = input;
  }

  setOutComment(String input){
    out_comment = input;
  }

  setCarInfo(PlateInfo info){
    plateInfo = info;
    notifyListeners();
  }
}
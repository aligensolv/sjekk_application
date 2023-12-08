import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/data/repositories/remote/car_repository_impl.dart';
import 'package:sjekk_application/data/repositories/remote/violation_repository.dart';
import '../../data/models/rule_model.dart';
import '../../data/repositories/remote/autosys_repository_impl.dart';


enum CreateViolationProviderErrorType{
  saving_error,
  none
}


class CreateViolationProvider extends ChangeNotifier{
  Violation? savedViolation;

  setSavedViolation({
    Violation? s_violation,
    Place? place
  }){
    savedViolation = Violation(
      rules: s_violation?.rules ?? [], 
      status: 'saved', 
      createdAt: DateTime.now().toLocal().toString(), 
      plateInfo: s_violation?.plateInfo ?? plateInfo!, 
      carImages: s_violation?.carImages ?? [], 
      place: s_violation?.place ?? place!, 
      paperComment: s_violation?.paperComment ?? '', 
      outComment: s_violation?.outComment ?? '', 
      is_car_registered: registeredCar != null, 
      registeredCar: registeredCar, 
      completedAt: null
    );
    notifyListeners();
  }

  // List<CarImage> carImages = [];
  // List<Rule> rules = [];
  // String paper_comment = "";
  // String out_comment = "";
  


  // int selectedPrintOptionIndex = 0;

  PlateInfo? plateInfo;
  RegisteredCar? registeredCar;
  bool isRegistered = false;

  bool errorState = false;
  String errorMessage = "";
  CreateViolationProviderErrorType errorType = CreateViolationProviderErrorType.none;

  clearErrors(){
    errorState = false;
    errorMessage = "";
  }


  clearAll(){
    // carImages.clear();
    // rules.clear();
    // paper_comment = '';
    // out_comment = '';
    // selectedPrintOptionIndex = 0;
    isRegistered = false;
    plateInfo = null;
    registeredCar = null;
    errorType = CreateViolationProviderErrorType.none;

    notifyListeners();
  }

  final _violationRepository = ViolationRepositoryImpl();
  Future<Violation?> saveViolation() async{
    print(savedViolation);
    try{
      Violation resultSavedViolation = await _violationRepository.saveViolation(
        violation: savedViolation!,
      );
      clearAll();
      return resultSavedViolation;
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
      errorType = CreateViolationProviderErrorType.saving_error;
      return null;
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

  createViolation({
    required Violation violation,
    required Place place,
    required List<String> selectedRules
  }) async{
    try{
      print(violation.toJson());
      print(place.toJson());
      print(selectedRules);
      await _violationRepository.createViolation(
        violation: violation,
        place: place,
        selectedRules: selectedRules
      );
      clearAll();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }

    notifyListeners();
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

  // updateSelectedPrintOptionIndex(index){
  //   selectedPrintOptionIndex = index;
  //   notifyListeners();
  // }

  // addRule(Rule rule){
  //   if(!rules.any((element) => element.id == rule.id)){
  //     rules.add(rule);
  //   }
  // }

  // removeRule(Rule rule){
  //   rules = rules.where((element) => element.id != rule.id).toList();
  // }

  // addImage(CarImage image){
  //   carImages.add(image);
  //   notifyListeners();
  // }

  // setPaperComment(String input){
  //   paper_comment = input;
  // }

  // setOutComment(String input){
  //   out_comment = input;
  // }

  setCarInfo(PlateInfo info){
    plateInfo = info;
    notifyListeners();
  }
}
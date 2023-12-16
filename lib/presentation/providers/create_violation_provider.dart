import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/data/repositories/remote/car_repository_impl.dart';
import 'package:sjekk_application/data/repositories/remote/violation_repository.dart';
import '../../data/repositories/remote/autosys_repository_impl.dart';


enum CreateViolationProviderErrorType{
  saving_error,
  getting_plate_info,
  none
}


class CreateViolationProvider extends ChangeNotifier{
  Violation? savedViolation;

  setSavedViolation({
    Violation? s_violation,
    Place? place
  }){
    savedViolation = s_violation;
    notifyListeners();
  }


  late PlateInfo plateInfo;
  RegisteredCar? registeredCar;
  bool isRegistered = false;

  bool errorState = false;
  String errorMessage = "";
  CreateViolationProviderErrorType errorType = CreateViolationProviderErrorType.none;

  Violation? existingSavedViolation;

  setExistingSavedViolation(String plate) async{
    if(plate.isEmpty){
      return;
    }
    Violation? _newSavedViolation = await ViolationRepositoryImpl().searchExistingSavedViolation(plate);
    existingSavedViolation = _newSavedViolation;
    notifyListeners();
  }

  clearErrors(){
    errorState = false;
    errorMessage = "";
  }


  clearAll(){
    isRegistered = false;
    registeredCar = null;
    existingSavedViolation = null;
    errorState = false;
    errorType = CreateViolationProviderErrorType.none;

    notifyListeners();
  }

  final _violationRepository = ViolationRepositoryImpl();
  Future<int?> saveViolation() async{
    try{
      int result = await _violationRepository.saveViolation(
        savedViolation!,
      );
      clearAll();
      return result;
    }catch(error){
      // rethrow;
      errorState = true;
      errorMessage = error.toString();
      errorType = CreateViolationProviderErrorType.saving_error;
      return 0;
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
  Future getCarInfo(String plate) async{
    try{
      if(plate.isEmpty){
        PlateInfo _plateInfo = PlateInfo.unknown(plate);
        setCarInfo(_plateInfo);
        notifyListeners();
        return;
      }
      final AutosysRepositoryImpl autosysRepository = AutosysRepositoryImpl();

      PlateInfo _plateInfo = await autosysRepository.getCarInfo(plate);
      setCarInfo(_plateInfo);
    }catch(error){
      errorState = true;
      errorType = CreateViolationProviderErrorType.getting_plate_info;
      notifyListeners();
    }
  }

  setCarInfo(PlateInfo info){
    plateInfo = info;
    notifyListeners();
  }
}
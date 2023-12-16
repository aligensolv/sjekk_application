import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:sjekk_application/data/models/car_type_model.dart';
import 'package:sjekk_application/data/repositories/remote/car_type_respository_impl.dart';

enum CarTypeProviderErrorType{
  none,
  error_getting_types
}

class CarTypeProvider extends ChangeNotifier{
  List<CarType> carTypes = [];
  List<CarType> originals = [];
  
  bool errorState = false;
  String errorMessage = "";
  CarTypeProviderErrorType errorType = CarTypeProviderErrorType.none;

  searchTypes(String query){
    carTypes = originals.where(
      (element) => element.value.toLowerCase().contains(query.toLowerCase())
    ).toList();

    notifyListeners();
  }

  Future getAllCarTypes() async{
    try{
      CarTypeRepositoryImpl carTypeRepository = CarTypeRepositoryImpl();
      carTypes = await carTypeRepository.getAllCarTypes();
      originals = carTypes;
      
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
      errorType = CarTypeProviderErrorType.error_getting_types;
    }

    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/data/repositories/remote/car_repository_impl.dart';

class CarProvider extends ChangeNotifier{
  List<RegisteredCar> cars = [];
  bool loadingState = false;
  bool errorState = false;
  String errorMessage = "";

  final CarRepositoryImpl _carRepositoryImpl = CarRepositoryImpl();

  clearErrors(){
    errorState = false;
    errorMessage = "";
  }

  fetchCars() async{
    try{
      loadingState = true;
      notifyListeners();
      
      cars = await _carRepositoryImpl.getAllCars();
      clearErrors();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    loadingState = false;
    notifyListeners();
  }

    fetchCarsByPlace(Place place) async{
    try{
      loadingState = true;
      notifyListeners();
      
      cars = await _carRepositoryImpl.getAllCarsByPlace(place);
      clearErrors();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    loadingState = false;
    notifyListeners();
  }
}
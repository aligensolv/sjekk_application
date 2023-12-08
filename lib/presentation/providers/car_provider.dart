import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/data/repositories/remote/car_repository_impl.dart';

class CarProvider extends ChangeNotifier{
  List<RegisteredCar> cars = [];
  List<RegisteredCar> originalCars = [];

  // bool loadingState = false;
  bool errorState = false;
  String errorMessage = "";

  final CarRepositoryImpl _carRepositoryImpl = CarRepositoryImpl();

    searchCars(String query) {
    cars = originalCars.where((car){
      return car.boardNumber.toLowerCase().contains(query.toLowerCase()) || 
      car.registerationType.toLowerCase().contains(query.toLowerCase());
    }).toList();

    notifyListeners();
  }

  clearErrors(){
    errorState = false;
    errorMessage = "";
  }

  fetchCars() async{
    try{
      // loadingState = true;
      // notifyListeners();
      
      cars = await _carRepositoryImpl.getAllCars();
      clearErrors();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    // loadingState = false;
    notifyListeners();
  }

    fetchCarsByPlace(Place place) async{
    try{
      // loadingState = true;
      // notifyListeners();
      
      cars = await _carRepositoryImpl.getAllCarsByPlace(place);
      originalCars = cars;
      clearErrors();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    // loadingState = false;
    notifyListeners();
  }
}
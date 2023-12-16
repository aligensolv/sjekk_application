import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/data/repositories/remote/violation_repository.dart';

class ViolationProvider extends ChangeNotifier{
  List<Violation> completedViolations = [];
  List<Violation> savedViolations = [];
  List<Violation> currentPlaceSavedViolations = [];
  List<Violation> currentPlaceCompletedViolations = [];
  bool errorState = false;
  String errorMessage = "";
  bool loadingState = false;

  clearErrors(){
    errorState = false;
    errorMessage = "";
  }

  // Future completeViolation(Violation violation) async{
  //   ViolationRepositoryImpl violationRepositoryImpl = ViolationRepositoryImpl();
  //   await violationRepositoryImpl.completeViolation(violation);
  // }

  fetchCompletedViolations() async{
    try{
      loadingState = true;
      notifyListeners();

      ViolationRepositoryImpl violationRepositoryImpl = ViolationRepositoryImpl();
      completedViolations = await violationRepositoryImpl.getCompletedViolations();

      clearErrors();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    loadingState = false;
    notifyListeners();
  }

  fetchSavedViolations() async{
    try{
      loadingState = true;
      notifyListeners();

      ViolationRepositoryImpl violationRepositoryImpl = ViolationRepositoryImpl();
      savedViolations = await violationRepositoryImpl.getAllSavedViolations();
      clearErrors();
    }catch(e){
      rethrow;
      errorState = true;
      errorMessage = e.toString();
    }

    loadingState = false;
    notifyListeners();
  }

  fetchPlaceSavedViolations(String id) async{
    try{
      print(id);
      loadingState = true;
      notifyListeners();

      ViolationRepositoryImpl violationRepositoryImpl = ViolationRepositoryImpl();
      currentPlaceSavedViolations = await violationRepositoryImpl.getPlaceSavedViolations(id);
      clearErrors();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    loadingState = false;
    notifyListeners();
  }

  fetchPlaceCompletedViolations(String id) async{
    try{
      print(id);
      loadingState = true;
      notifyListeners();

      ViolationRepositoryImpl violationRepositoryImpl = ViolationRepositoryImpl();
      currentPlaceCompletedViolations = await violationRepositoryImpl.getPlaceCompletedViolations(id);
      clearErrors();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    loadingState = false;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:sjekk_application/data/repositories/remote/place_repository_impl.dart';

import '../../data/models/place_model.dart';

class PlaceProvider extends ChangeNotifier {
  List<Place> places = [];
  List<Place> originalPlaces = [];
  bool errorState = false;
  String errorMessage = "";
  bool loadingState = false;

  Place? selectedPlace;
  DateTime? selectedPlaceLoginTime;
  DateTime? startTime;

  restartStartTime(){
    startTime = DateTime.now().toLocal();
    notifyListeners();
  }

  setSelectedPlace(Place place){
    selectedPlace = place;
  }

  setSelectedPlaceLoginTime(){
    selectedPlaceLoginTime = DateTime.now();
  }

  logoutFromCurrentPlace(){
    selectedPlace = null;
    selectedPlaceLoginTime = null;
  }

  clearErrors(){
    errorState = false;
    errorMessage = "";
  }

  fetchPlaces() async {
    try {
      loadingState = true;
      notifyListeners();

      PlaceRepositoryImpl placeRepositoryImpl = PlaceRepositoryImpl();
      List<Place> fetchedPlaces = await placeRepositoryImpl.getAllPlaces();
      places = fetchedPlaces;
      originalPlaces = fetchedPlaces;
      clearErrors();
    } catch (error) {
      errorState = true;
      errorMessage = error.toString();
    }

    loadingState = false;
    notifyListeners();
    // clearErrors();
  }

  searchPlaces(String query) {
    places = originalPlaces.where((place){
      return place.location.toLowerCase().contains(query.toLowerCase()) || 
      place.code.toLowerCase().contains(query.toLowerCase());
    }).toList();

    notifyListeners();
  }
}

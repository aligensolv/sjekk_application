import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:sjekk_application/data/models/color_model.dart';
import 'package:sjekk_application/data/repositories/remote/brand_repository_impl.dart';
import 'package:sjekk_application/data/repositories/remote/color_repository_impl.dart';
import '../../data/models/brand_model.dart';

enum ColorProviderErrorType{
  none,
  error_getting_colors
}

class ColorProvider extends ChangeNotifier{
  List<CarColor> colors = [];
  List<CarColor> originals = [];
  
  bool errorState = false;
  String errorMessage = "";
  ColorProviderErrorType errorType = ColorProviderErrorType.none;

  searchColors(String query){
    colors = originals.where(
      (element) => element.value.toLowerCase().contains(query.toLowerCase())
    ).toList();

    notifyListeners();
  }

  Future getAllColors() async{
    try{
      ColorRepositoryImpl impl = ColorRepositoryImpl();
      colors = await impl.getAllColors();
      originals = colors;

    }catch(error){
      errorState = true;
      errorMessage = error.toString();
      errorType = ColorProviderErrorType.error_getting_colors;
    }

    notifyListeners();
  }
}
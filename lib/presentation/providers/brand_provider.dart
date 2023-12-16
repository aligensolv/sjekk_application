import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:sjekk_application/data/repositories/remote/brand_repository_impl.dart';
import '../../data/models/brand_model.dart';

enum BrandProviderErrorType{
  none,
  error_getting_brands
}

class BrandProvider extends ChangeNotifier{
  List<Brand> brands = [];
  List<Brand> originals = [];
  
  bool errorState = false;
  String errorMessage = "";
  BrandProviderErrorType errorType = BrandProviderErrorType.none;

  searchBrands(String query){
    brands = originals.where(
      (element) => element.value.toLowerCase().contains(query.toLowerCase())
    ).toList();

    notifyListeners();
  }

  Future getAllBrands() async{
    try{
      BrandRepositoryImpl impl = BrandRepositoryImpl();
      brands = await impl.getAllBrands();
      originals = brands;

    }catch(error){
      errorState = true;
      errorMessage = error.toString();
      errorType = BrandProviderErrorType.error_getting_brands;
    }

    notifyListeners();
  }
}
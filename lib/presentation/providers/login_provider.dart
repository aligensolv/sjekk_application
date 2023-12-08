import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/user_model.dart';

import '../../data/entities/auth_credentials.dart';
import '../../data/repositories/remote/auth_repository_impl.dart';

class LoginProvider extends ChangeNotifier{
  final AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();
  // bool loadingState = false;

  bool errorState = false;
  String errorMessage = "";

  clearErrors(){
    errorMessage = "";
    errorState = false;
  }

  // changeLoadingState(bool state){
  //   loadingState = state;
  //   notifyListeners();
  // }

  Future<User?> login(AuthCredentials authCredentials) async{
    try{
      // changeLoadingState(true);

      User? user = await authRepositoryImpl.loginUser(authCredentials);
      clearErrors();
      return user;
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
      // changeLoadingState(false);
      notifyListeners();
      return null;
    }
  }
}
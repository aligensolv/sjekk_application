import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/place_login_model.dart';
import 'package:sjekk_application/data/models/shift_model.dart';
import 'package:sjekk_application/data/repositories/local/cache_repository_impl.dart';
import 'package:sjekk_application/data/repositories/remote/shift_repository_impl.dart';
import 'package:sjekk_application/presentation/providers/auth_provider.dart';

import '../../core/utils/logger.dart';

class ShiftProvider extends ChangeNotifier{
  Shift? shift;
  final ShiftRepository _shiftRepository = ShiftRepository();

  static ShiftProvider? _instance;

  // Private constructor to prevent external instantiation
  ShiftProvider._();

  // Singleton instance getter
  static ShiftProvider get instance {
    _instance ??= ShiftProvider._();
    return _instance!;
  }
  Future init() async{
    if(AuthProvider.instance.authenticated){
      final shiftId = await CacheRepositoryImpl.instance.get('shift_id');
      final startDate = await CacheRepositoryImpl.instance.get('shift_start_date');
      final List decoded = jsonDecode(
        await CacheRepositoryImpl.instance.get('logins') ?? '[]'
      );

      final List<PlaceLogin> logins = decoded.map((e) => PlaceLogin.fromJson(e)).toList();
      pinfo(logins);

      final instance = Shift(
        id: shiftId ?? '', 
        startDate: startDate ?? '',
        logins: logins
      );
      shift = instance;
    }
  }

  Future<bool> startNewShift(String token) async{
    try{
      shift = await _shiftRepository.startNewShift(token);
      return true;
    }catch(error){
      print(error.toString());
      return false;
    }
  }

  Future storePlaceLogin(PlaceLogin placeLogin) async{
    try{
      String encoded = await CacheRepositoryImpl.instance.get('logins') ?? '[]';
      List decoded = jsonDecode(encoded);
      List<PlaceLogin> logins = decoded.map((e) => PlaceLogin.fromJson(e)).toList();
      logins.add(placeLogin);

      await CacheRepositoryImpl.instance.set('logins', jsonEncode(logins));
    }catch(error){
      rethrow;
    }
  }

  Future<bool> endShift() async{
    try{
      await _shiftRepository.endShift(shift!.id);
      return true;
    }catch(error){
      return false;
    }
  }
}
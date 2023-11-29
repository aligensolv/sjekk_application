import 'dart:convert';

import 'package:sjekk_application/core/constants/app_constants.dart';
import 'package:sjekk_application/core/utils/build_headers.dart';
import 'package:sjekk_application/data/models/shift_model.dart';
import 'package:sjekk_application/data/repositories/local/cache_repository_impl.dart';
import 'package:sjekk_application/domain/repositories/shift_repository.dart';
import 'package:http/http.dart' as http;

class ShiftRepository implements IShiftRepository{
  @override
  Future<void> endShift(String id) async{
        try{
      final uri = Uri.parse('$baseUrl/shifts/$id/end');
      String? token = await CacheRepositoryImpl.instance.get('token');

      final response = await http.post(
        uri,
        headers: BuildHeaders().supportJson().add('token',token.toString()).finish(),
      );

      if(response.statusCode == 200){
        final cacheRepository = CacheRepositoryImpl.instance;
        await cacheRepository.remove('shift_id');
        await cacheRepository.remove('shift_start_date');
        return;
      }else{
        Map decoded = jsonDecode(response.body);
        throw decoded['error'];
      }
    }catch(error){
      rethrow;
    }
  }

  @override
  Future<Shift> startNewShift(String token) async{
    try{
      final uri = Uri.parse('$baseUrl/shifts');
      final response = await http.post(
        uri,
        headers: BuildHeaders().supportJson().add('token',token).finish(),
      );

      if(response.statusCode == 200){
        Map decoded = jsonDecode(response.body);
        Shift shift = Shift.fromJson(decoded);

        final cacheRepository = CacheRepositoryImpl.instance;
        await cacheRepository.set('shift_id', shift.id);
        await cacheRepository.set('shift_start_date', shift.startDate);
        return shift;
      }else{
        Map decoded = jsonDecode(response.body);
        throw decoded['error'];
      }
    }catch(error){
      rethrow;
    }
  }
}
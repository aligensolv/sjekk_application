import 'dart:convert';

import 'package:sjekk_application/core/constants/app_constants.dart';
import 'package:sjekk_application/data/models/car_type_model.dart';
import 'package:sjekk_application/domain/repositories/car_type_repository.dart';
import 'package:http/http.dart' as http;

class CarTypeRepositoryImpl implements ICarTypeRepository{
  @override
  Future<List<CarType>> getAllCarTypes() async{
    try{
      final uri = Uri.parse('$baseUrl/types');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<CarType> carTypes = decoded.map((e){
          return CarType.fromJson(e);
        }).toList();

        return carTypes;
      }else{
        Map decoded = jsonDecode(response.body);
        throw decoded['error'];
      }
    }catch(error){
      rethrow;
    }
  }
}
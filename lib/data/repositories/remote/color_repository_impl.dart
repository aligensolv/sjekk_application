import 'dart:convert';

import 'package:sjekk_application/data/models/color_model.dart';
import 'package:sjekk_application/domain/repositories/color_repository.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';

class ColorRepositoryImpl implements IColorRepository{
  @override
  Future<List<CarColor>> getAllColors() async{
    try{
      final uri = Uri.parse('$baseUrl/colors');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<CarColor> colors = decoded.map((e){
          return CarColor.fromJson(e);
        }).toList();

        return colors;
      }else{
        Map decoded = jsonDecode(response.body);
        throw decoded['error'];
      }
    }catch(error){
      rethrow;
    }
  }
}
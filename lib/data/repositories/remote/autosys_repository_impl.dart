import 'dart:convert';

import 'package:sjekk_application/core/constants/app_constants.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/domain/repositories/autosys_repository.dart';
import 'package:http/http.dart' as http;

class AutosysRepositoryImpl implements IAutosysRepository{
  @override
  Future<PlateInfo> getCarInfo(String plate) async{
    try{
      final uri = Uri.parse('$baseUrl/autosys/$plate');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        Map decoded = jsonDecode(response.body);
        print(decoded);
        PlateInfo plateInfo = PlateInfo.fromJson(decoded);
        return plateInfo;
      }else{
        PlateInfo plateInfo = PlateInfo.unknown(plate);
        return plateInfo;
      }
    }catch(error){
      rethrow;
    }
  }  
}
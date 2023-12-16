import 'dart:convert';

import 'package:sjekk_application/data/models/brand_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../domain/repositories/brand_repository.dart';

class BrandRepositoryImpl extends IBrandRepository{
  @override
  Future<List<Brand>> getAllBrands() async{
    try{
      final uri = Uri.parse('$baseUrl/brands');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<Brand> brands = decoded.map((e){
          return Brand.fromJson(e);
        }).toList();

        return brands;
      }else{
        Map decoded = jsonDecode(response.body);
        throw decoded['body'];
      }
    }catch(error){
      rethrow;
    }
  }
}
import 'dart:convert';

import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/domain/repositories/car_repository.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';
import '../../models/plate_info_model.dart';
import '../local/cache_repository_impl.dart';

class CarRepositoryImpl implements ICarRepository{
  @override
  Future<List<RegisteredCar>> getAllCars() async{
        try {
      final uri = Uri.parse('$baseUrl/cars');
      String? token = await CacheRepositoryImpl.instance.get('token');

      final response =
          await http.get(
            uri,
            headers: {'token': token.toString()},
          );

      if (response.statusCode == 200) {
        List decoded = jsonDecode(response.body);

        List<RegisteredCar> cars = decoded.map((el) {
          return RegisteredCar.fromJson(el);
        }).toList();

        return cars;
      }else if(response.statusCode == 408){
        throw response.body;
      } else {
        Map json = jsonDecode(response.body);
        throw json['error'];
      }
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

    @override
  Future<List<RegisteredCar>> getAllCarsByPlace(Place place) async{
        try {
      final uri = Uri.parse('$baseUrl/cars/place/${place.id}');
      String? token = await CacheRepositoryImpl.instance.get('token');

      final response =
          await http.get(
            uri,
            headers: {'token': token.toString()},
          );

      if (response.statusCode == 200) {
        List decoded = jsonDecode(response.body);

        List<RegisteredCar> cars = decoded.map((el) {
          return RegisteredCar.fromJson(el);
        }).toList();

        return cars;
      }else if(response.statusCode == 408){
        throw response.body;
      } else {
        Map json = jsonDecode(response.body);
        throw json['error'];
      }
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  @override
  Future<RegisteredCar> getCarByPlate(String plate) async{
            try {
              print(plate);
      final uri = Uri.parse('$baseUrl/cars/plate/$plate');
      String? token = await CacheRepositoryImpl.instance.get('token');

      final response =
          await http.get(
            uri,
            headers: {'token': token.toString()},
          );

      print(response.statusCode);
      if (response.statusCode == 200) {
        Map car = jsonDecode(response.body);

        return RegisteredCar.fromJson(car);
      }else {
        Map json = jsonDecode(response.body);
        throw json['error'];
      }
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }  
}
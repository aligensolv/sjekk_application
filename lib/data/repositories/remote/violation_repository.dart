import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_constants.dart';
import 'package:sjekk_application/core/utils/build_headers.dart';
import 'package:sjekk_application/data/models/rule_model.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/data/repositories/local/cache_repository_impl.dart';
import 'package:sjekk_application/domain/repositories/violation_repository.dart';
import 'package:http/http.dart' as http;
import 'package:sjekk_application/presentation/providers/create_violation_provider.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/providers/rule_provider.dart';

import '../../models/place_model.dart';

class ViolationRepositoryImpl extends IViolationRepository{
  @override
  Future<List<Violation>> getCompletedViolations() async{
    final uri = Uri.parse('$baseUrl/violations/completed');
    String? token = await CacheRepositoryImpl.instance.get('token');

    final response = await http.get(
      uri,
      headers: {
        'token': token.toString(),
      }
    );

    if(response.statusCode == 200){
      List decoded = jsonDecode(response.body);
      List<Violation> violations = decoded.map((e){
        return Violation.fromJson(e);
      }).toList();

      return violations;
    }else{
      Map decoded = jsonDecode(response.body);
      throw decoded['error'];
    }
  }

  @override
  Future<List<Violation>> getSavedViolations() async{
    try{
          final uri = Uri.parse('$baseUrl/violations/saved');
    String? token = await CacheRepositoryImpl.instance.get('token');

    final response = await http.get(
      uri,
      headers: {
        'token': token.toString(),
      }
    );

    if(response.statusCode == 200){
      List decoded = jsonDecode(response.body);
      print(decoded);
      List<Violation> violations = decoded.map((e){
        return Violation.fromJson(e);
      }).toList();


      print(violations);
      return violations;
    }else{
      Map decoded = jsonDecode(response.body);
      throw decoded['error'];
    }
    }catch(error){
      print(error);
      rethrow;
    }
  }
  
  @override
  Future<List<Violation>> getPlaceViolations(String id) async{
    try{
          final uri = Uri.parse('$baseUrl/violations/place/$id');
    String? token = await CacheRepositoryImpl.instance.get('token');

    final response = await http.get(
      uri,
      headers: {
        'token': token.toString(),
      }
    );

    print(response.statusCode);

    if(response.statusCode == 200){
      List decoded = jsonDecode(response.body);
      List<Violation> violations = decoded.map((e){
        return Violation.fromJson(e);
      }).toList();

      return violations;
    }else{
      Map decoded = jsonDecode(response.body);
      throw decoded['error'];
    }
    }catch(e){
      rethrow;
    }
  }
  
  @override
  Future<void> createViolation({
    required Violation violation,
    required Place place,
    required List<String> selectedRules
  }) async{
    try{

      final cacheRepository = CacheRepositoryImpl.instance;

      final Uri uri = Uri.parse("$baseUrl/violations");
      var request = http.MultipartRequest('POST', uri);

      for(final image in violation.carImages){
        request.files.add(await http.MultipartFile.fromPath(image.path, image.path));
      }      

      String? token = await cacheRepository.get('token');
      request.headers.addAll({
        'token': token.toString()
      });

      request.fields.addAll({
        'plate_info': jsonEncode(violation.plateInfo.toJson()),
        'registered_car_info': jsonEncode(violation.registeredCar!.toJson()),
        'status': 'completed',
        'rules': jsonEncode(selectedRules),
        'place': place.id,
        'paper_comment': violation.paperComment,
        'created_at':violation.createdAt,
        'completed_at': DateTime.now().toLocal().toString(),
        'out_comment': violation.outComment,
        'is_car_registered': jsonEncode(violation.is_car_registered)
      });

            var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle success response if needed
        print('Data and files/images uploaded successfully');
      } else {
        throw await response.stream.bytesToString();
      }
    }catch(error){
      print(error.toString());
      rethrow;
    }
  }

   @override
  Future<void> completeViolation(Violation violation) async{
    try{
      final uri = Uri.parse('$baseUrl/violations/${violation.id}/complete');
      String? token = await CacheRepositoryImpl.instance.get('token');

      final response = await http.put(
        uri,
        headers: BuildHeaders().supportJson().add('token', token.toString()).finish() ,
      );

      if(response.statusCode == 200){
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
  Future<Violation> saveViolation({
    required Violation violation,
    required Place place,
    required List<String> selectedRules
  }) async{
    try{
      final cacheRepository = CacheRepositoryImpl.instance;

      final Uri uri = Uri.parse("$baseUrl/violations");
      var request = http.MultipartRequest('POST', uri);

      for(final image in violation.carImages){
        request.files.add(await http.MultipartFile.fromPath(image.path, image.path));
      }      

      String? token = await cacheRepository.get('token');
      request.headers.addAll({
        'token': token.toString()
      });

      request.fields.addAll({
        'plate_info': jsonEncode(violation.plateInfo.toJson()),
        'registered_car_info': jsonEncode(violation.registeredCar!.toJson()),
        'status': 'saved',
        'rules': jsonEncode(selectedRules),
        'place': place.id,
        'paper_comment': violation.paperComment,
        'created_at':violation.createdAt,
        'out_comment': violation.outComment,
        'is_car_registered': jsonEncode(violation.is_car_registered)
      });


            var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('i got result');
        Map decoded = jsonDecode(await response.stream.bytesToString());
        print('printing it niw');
        print(decoded);
        Violation violation = Violation.fromJson(decoded);
        print('violation returned is ....');
        print(violation);

        return violation;
      } else {
        throw await response.stream.bytesToString();
      }
    }catch(error){
      print(error.toString());
      rethrow;
    }
  }
  
  // @override
  // Future<void> completeViolation(Violation violation) async{
  //   try{
  //     final uri = Uri.parse('$baseUrl/violations/${violation.id}/complete');
  //     String? token = await CacheRepositoryImpl.instance.get('token');

  //     final response = await http.put(
  //       uri,
  //       headers: BuildHeaders().supportJson().add('token', token.toString()).finish() ,
  //     );

  //     if(response.statusCode == 200){
  //       return;
  //     }else{
  //       Map decoded = jsonDecode(response.body);
  //       throw decoded['error'];
  //     }
  //   }catch(error){
  //     rethrow;
  //   }
  // }
  
  @override
  Future<String> addImage(String id, String image) async{
    try{
      final cacheRepository = CacheRepositoryImpl.instance;

      final Uri uri = Uri.parse("$baseUrl/violations/$id/images");
      var request = http.MultipartRequest('PUT', uri);
      request.files.add(await http.MultipartFile.fromPath('image', image));


      String? token = await cacheRepository.get('token');
      request.headers.addAll({
        'token': token.toString()
      });

                var response = await request.send();

      print(response.statusCode);
      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        throw await response.stream.bytesToString();
      }

    }catch(error){
      rethrow;
    }
  }

  @override
  Future<Rule> addRule(String violationId,String ruleId) async{
    try{
      final uri = Uri.parse('$baseUrl/violations/$violationId/rules');
      final response = await http.put(
        uri,
        headers: BuildHeaders().supportJson().finish(),
        body: jsonEncode({
          'rule': ruleId
        })
      );

      if(response.statusCode == 200){
        Rule rule = Rule.fromJson(
          jsonDecode(response.body)
        );

        return rule;
      }else{
        Map decoded = jsonDecode(response.body);
        throw decoded['error'];
      }
    }catch(error){
      rethrow;
    }
  }
  
  @override
  Future<void> deleteViolation(Violation violation) async{
    try{
      final uri = Uri.parse('$baseUrl/violations/${violation.id}');
      final response = await http.delete(uri);

      if(response.statusCode == 200){
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
  Future<String> updateInnerComment(String violationId, String comment) async{
    try{
      final uri = Uri.parse('$baseUrl/violations/$violationId/innerComment');
      final response = await http.put(
        uri,
        headers: BuildHeaders().supportJson().finish(),
        body: jsonEncode({
          'comment': comment
        })
      );

      if(response.statusCode == 200){
        return response.body;
      }else{
        Map decoded = jsonDecode(response.body);
        throw decoded['error'];
      }
    }catch(error){
      rethrow;
    }
  }
  
  @override
  Future<String> updateOutterComment(String violationId, String comment) async{
    try{
      final uri = Uri.parse('$baseUrl/violations/$violationId/outterComment');
      final response = await http.put(
        uri,
        headers: BuildHeaders().supportJson().finish(),
        body: jsonEncode({
          'comment': comment
        })
      );

      if(response.statusCode == 200){
        return response.body;
      }else{
        Map decoded = jsonDecode(response.body);
        throw decoded['error'];
      }
    }catch(error){
      rethrow;
    }
  }
  
}
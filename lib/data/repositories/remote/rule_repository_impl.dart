import 'dart:convert';

import 'package:sjekk_application/core/constants/app_constants.dart';
import 'package:sjekk_application/data/models/rule_model.dart';
import 'package:sjekk_application/domain/repositories/rule_repository.dart';
import 'package:http/http.dart' as http;

class RuleRepositoryImpl implements IRuleRepository{
  @override
  Future<List<Rule>> getAllRules() async{
    try{
      final uri = Uri.parse('$baseUrl/rules');
      final response = await http.get(uri);
      List decoded = jsonDecode(response.body);
      List<Rule> rules = decoded.map((e){
        return Rule.fromJson(e);
      }).toList();


      return rules;
    }catch(e){
      rethrow;
    }
  }
  
}
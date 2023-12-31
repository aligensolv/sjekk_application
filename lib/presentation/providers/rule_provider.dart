import 'package:flutter/material.dart';
import 'package:sjekk_application/data/repositories/remote/rule_repository_impl.dart';

import '../../data/models/rule_model.dart';

class RuleProvider extends ChangeNotifier{
  List<Rule> rules = [];
  List<String> selected = [];
  String errorMessage = "";
  bool errorState = false;

  final RuleRepositoryImpl _ruleRepositoryImpl = RuleRepositoryImpl();

  clearErrors(){
    errorState = false;
    errorMessage = "";
  }

  fetchRules() async{
    try{
      rules = await _ruleRepositoryImpl.getAllRules();
      rules.sort(
      (a, b){
            var partsA = a.name.split('-');
            var numberA = int.parse(partsA[0]);
            var partsB = b.name.split('-');
            var numberB = int.parse(partsB[0]);

            return numberA - numberB;
      }
  );
      clearErrors();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  select(String id){
    if(!contains(id)){
      selected.add(id);
      notifyListeners();
    }
  }

  unselect(String id){
    if(contains(id)){
      selected.remove(id);
      notifyListeners();
    }
  }

  bool contains(id){
    return selected.contains(id);
  }
}
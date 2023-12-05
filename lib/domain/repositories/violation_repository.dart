import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/rule_model.dart';
import 'package:sjekk_application/data/models/violation_model.dart';

abstract class IViolationRepository{
  Future<List<Violation>> getCompletedViolations();
  Future<List<Violation>> getSavedViolations();
  Future<List<Violation>> getPlaceViolations(String id);

  Future<void> createViolation({
    required Violation violation,
    required Place place,
    required List<String> selectedRules
  });
    Future<void> completeViolation(Violation violation);

  Future<Violation> saveViolation({
    required Violation violation,
    required Place place,
    required List<String> selectedRules
  });


  Future<void> deleteViolation(Violation violation);

  Future<String> addImage(String id, String image);
  Future<Rule> addRule(String violationId, String ruleId);

  Future<String> updateInnerComment(String violationId, String comment);
  Future<String> updateOutterComment(String violationId, String comment);
}
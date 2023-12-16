import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/rule_model.dart';
import 'package:sjekk_application/data/models/violation_model.dart';

abstract class IViolationRepository{
  Future<List<Violation>> getCompletedViolations();

  Future<List<Violation>> getPlaceSavedViolations(String id);
  Future<List<Violation>> getPlaceCompletedViolations(String id);

  Future<Violation?> searchExistingSavedViolation(String plateNumber);

  Future<void> createViolation({
    required Violation violation,
    required Place place,
    required List<String> selectedRules
  });

    Future<void> uploadViolationToServer(Violation violation);
    Future<String> uploadImage(String id, String image);

  Future<int> saveViolation(Violation violation);
  Future copyViolation(Violation violation);

  Future updateViolation(int? id, Map<String,dynamic> data);

  Future deleteViolation(Violation violation);

  Future<List<Violation>> getAllSavedViolations();
  Future<Violation> getViolation(int? id);
}
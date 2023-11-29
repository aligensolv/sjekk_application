import 'package:sjekk_application/data/models/violation_model.dart';

abstract class ILocalViolationRepository{
  Future<List<Violation>> getLocalViolations();
  Future createLocalViolation(Violation violation);
}
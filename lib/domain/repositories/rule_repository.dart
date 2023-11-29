import 'package:sjekk_application/data/models/rule_model.dart';

abstract class IRuleRepository{
  Future<List<Rule>> getAllRules();
}
import 'package:sjekk_application/data/models/shift_model.dart';

abstract class IShiftRepository{
  Future<Shift> startNewShift(String id);
  Future<void> endShift(String id);
}
import 'package:sjekk_application/data/models/color_model.dart';

abstract class IColorRepository{
  Future<List<CarColor>> getAllColors();
}
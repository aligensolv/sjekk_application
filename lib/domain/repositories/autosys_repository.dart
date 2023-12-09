import 'package:sjekk_application/data/models/plate_info_model.dart';

abstract class IAutosysRepository{
  Future<PlateInfo?> getCarInfo(String plate);
}
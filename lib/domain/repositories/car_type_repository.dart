import 'package:sjekk_application/data/models/car_type_model.dart';

abstract class ICarTypeRepository{
  Future<List<CarType>> getAllCarTypes();
}
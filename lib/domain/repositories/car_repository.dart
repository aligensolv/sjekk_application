import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';


abstract class ICarRepository{
  Future<List<RegisteredCar>> getAllCars();
  Future<List<RegisteredCar>> getAllCarsByPlace(Place place);
  Future<RegisteredCar> getCarByPlate(String plate);
}
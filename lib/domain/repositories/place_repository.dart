import 'package:sjekk_application/data/models/place_model.dart';

abstract class IPlaceRepository{
  Future<List<Place>> getAllPlaces();
}
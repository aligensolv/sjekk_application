import '../../data/models/brand_model.dart';

abstract class IBrandRepository{
  Future<List<Brand>> getAllBrands();
}
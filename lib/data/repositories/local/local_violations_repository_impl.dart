import 'package:sjekk_application/core/helpers/sqflite_helper.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/domain/repositories/local_violation_repository.dart';

class LocalViolationRepositoryImpl implements ILocalViolationRepository{
  DatabaseHelper instance = DatabaseHelper.instance;

  @override
  Future createLocalViolation(Violation violation) async{
    try{
      int result = await instance.insertData('violations', violation.toJson());
      print(result);
      
      return result > 0;
    }catch(error){
      rethrow;
    }
  }

  @override
  Future<List<Violation>> getLocalViolations() {
    // TODO: implement getLocalViolations
    throw UnimplementedError();
  }
  
}
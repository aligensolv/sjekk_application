import 'package:sjekk_application/core/helpers/sqflite_helper.dart';
import 'package:sjekk_application/data/models/printer_model.dart';
import 'package:sjekk_application/domain/repositories/printer_repository.dart';

class PrinterRepository implements IPrinterRepository{
  @override
  Future<void> createPriner(Printer printer) async{
    try{
      await DatabaseHelper.instance.insertData('printer', printer.toJson());
      return;
    }catch(error){
      rethrow;
    }
  }

  @override
  Future<bool> deletePrinter(int id) async{
    try{
      return await DatabaseHelper.instance.removeDataById('printer', id) > 0;
    }catch(error){
      rethrow;
    }
  }

  @override
  Future<List<Printer>> getAllPrinters() async{
    try{
      List data = await DatabaseHelper.instance.getAllData('printer');
      List<Printer> printers = data.map((e){
        return Printer.fromJson(e);
      }).toList();

      return printers;
    }catch(error){
      rethrow;
    }
  }

  @override
  Future<Printer> getPrinter(int id) async{
    try{
      Map data = await DatabaseHelper.instance.getPrinter('printer', id);
      Printer printer = Printer.fromJson(data);
      return printer;
    }catch(error){
      rethrow;
    }
  }

  @override
  Future<bool> updatePrinter(int id, Map<String,dynamic> data) async{
    try{
      return await DatabaseHelper.instance.updateData('printer', id, data) > 0;
    }catch(error){
      rethrow;
    }
  }
}
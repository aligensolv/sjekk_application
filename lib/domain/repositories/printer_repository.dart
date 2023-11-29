import 'package:sjekk_application/data/models/printer_model.dart';

abstract class IPrinterRepository{
  Future<void> createPriner(Printer printer);
  Future<List<Printer>> getAllPrinters();
  Future<Printer> getPrinter(int id);
  Future<bool> updatePrinter(int id, Map<String,dynamic> data);
  Future<bool> deletePrinter(int id);
}
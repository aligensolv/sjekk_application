import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/printer_model.dart';
import 'package:sjekk_application/data/repositories/local/printer_repositories.dart';

class PrinterProvider extends ChangeNotifier{
  List<Printer> printers = [];
  bool errorState = false;
  String errorMessage = '';
  bool loadingState = false;
  final PrinterRepository _printerRepository = PrinterRepository();

  update(){
    notifyListeners();
  }

  fetchPrinters() async{
    loadingState = true;
    notifyListeners();

    try{
      printers = await _printerRepository.getAllPrinters();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    loadingState = false;
    notifyListeners();
  }

  createPrinter(Printer printer) async{
    await _printerRepository.createPriner(printer);
  }
}
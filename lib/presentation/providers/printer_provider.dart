import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/printer_model.dart';
import 'package:sjekk_application/data/repositories/local/printer_repositories.dart';

class PrinterProvider extends ChangeNotifier{
  List<Printer> printers = [];
  bool errorState = false;
  String errorMessage = '';
  // bool loadingState = false;
  final PrinterRepository _printerRepository = PrinterRepository();

  clear(){
    errorMessage = '';
    errorState = false;
  }

  pushPrinter(Printer printer){
    printers.add(printer);
    notifyListeners();
  }

  createPrinter(Printer printer) async{
      try{
        await _printerRepository.createPriner(printer);
        pushPrinter(printer);
        clear();
      }catch(error){
        errorMessage = error.toString();
        errorState = true;
      }

      notifyListeners();
  }

  fetchPrinters() async{
    // loadingState = true;
    // notifyListeners();

    try{
      printers = await _printerRepository.getAllPrinters();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    // loadingState = false;
    notifyListeners();
  }
}
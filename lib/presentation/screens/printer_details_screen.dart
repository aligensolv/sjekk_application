import 'package:flutter/material.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/printer_model.dart';
import 'package:sjekk_application/data/repositories/local/printer_repositories.dart';

class PrinterDetailsScreen extends StatelessWidget {
  final Printer printer;

  const PrinterDetailsScreen({Key? key, required this.printer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Printer Name: ${printer.name}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Printer Address: ${printer.address}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {

                  },
                  style: ThemeHelper.normalPrimaryButtonStyle(context),
                  child: Text('Test Printer (Exp)',style: TextStyle(
                    color: Colors.white
                  ),),
                ),
                SizedBox(width: 12.0,),
                ElevatedButton(
                  onPressed: () async{
                    bool? wasDeleted = await _showDeleteConfirmationDialog(context);
                    if(wasDeleted ?? false){
                      SnackbarUtils.showSnackbar(context, 'Printer was deleted',type: SnackBarType.success);
                      Navigator.pop(context);
                    }else{
                      SnackbarUtils.showSnackbar(context, 'Failed to delete printer',type: SnackBarType.failure);
                    }
                  },
                  style: ThemeHelper.normalPrimaryButtonStyle(context).copyWith(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)
                  ),
                  child: Text('Delete Printer',style: TextStyle(
                    color: Colors.white
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

    Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Printer'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this printer?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async{
                
                try{
                  PrinterRepository printerRepository = PrinterRepository();
                  await printerRepository.deletePrinter(printer.id!);
                  Navigator.of(context).pop(true); // Close the dialog
                }catch(e) {
                  Navigator.of(context).pop(false); // Close the dialog
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Use your desired color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
                )
              ),
              child: Text('Confirm',style: TextStyle(
                color: Colors.white
              ),),
            ),
          ],
        );
      },
    );
  }
}

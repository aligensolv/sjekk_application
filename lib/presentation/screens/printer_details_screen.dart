import 'package:flutter/material.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/printer_model.dart';
import 'package:sjekk_application/data/repositories/local/printer_repositories.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_dialog.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

class PrinterDetailsScreen extends StatelessWidget {
  final Printer printer;

  const PrinterDetailsScreen({Key? key, required this.printer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TemplateHeadlineText(
                'Printer Name: ${printer.name}',
              ),
              const SizedBox(height: 12),
              TemplateHeadlineText(
                'Printer Address: ${printer.address}',
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  NormalTemplateButton(
                    onPressed: () {
    
                    },
                    text: 'TEST',
                  ),
                  const SizedBox(width: 12.0,),
                  DangerTemplateButton(
                    onPressed: () async{
                      await _showDeleteConfirmationDialog(context);
                    },
                    text: 'DELETE',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

    Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TemplateConfirmationDialog(
          onConfirmation: () async{
            try{
              PrinterRepository printerRepository = PrinterRepository();
              await printerRepository.deletePrinter(printer.id!);
            }catch(error) {
              SnackbarUtils.showSnackbar(context, error.toString());
            }
          }, 
          title: 'Confirm Delete', 
          message: 'Delete Printer \'${printer.name}\''
        );
      },
    );
  }
}

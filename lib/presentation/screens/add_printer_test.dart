import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/printer_model.dart';
import 'package:sjekk_application/presentation/providers/printer_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_dialog.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';


class AddPrinterTest extends StatefulWidget {
  static const String route = "add_printer_test";  
  const AddPrinterTest({Key? key}) : super(key: key);

  @override
  _AddPrinterTestState createState() => _AddPrinterTestState();
}

class _AddPrinterTestState extends State<AddPrinterTest> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            24.h,
            NormalTemplateTextField(
              controller: nameController,
              hintText: 'Name',
            ),
            SizedBox(height: 16),
            NormalTemplateTextField(
              controller: addressController,
              hintText: 'Address',
            ),
            12.h,
            NormalTemplateButton(
              onPressed: () async{
                await _showConfirmationDialog();
                Navigator.pop(context);
              },
              text:'Create',
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TemplateConfirmationDialog(
          onConfirmation: () async{
                Printer printer = Printer(
                  address: addressController.text,
                  name: nameController.text
                );

                final provider = Provider.of<PrinterProvider>(context,listen: false);
                await provider.createPrinter(printer);

                if(provider.errorState){
                  SnackbarUtils.showSnackbar(context, provider.errorMessage, type: SnackBarType.failure);
                  return;
                }
                
                Navigator.of(context).pop();
                SnackbarUtils.showSnackbar(context, 'Printer created successfully');
          }, 
          title: 'Confirmation', 
          message: 'Are you sure you want to create this printer?'
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }
}

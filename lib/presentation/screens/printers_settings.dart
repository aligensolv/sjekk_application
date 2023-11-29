import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/presentation/providers/printer_provider.dart';
import 'package:sjekk_application/presentation/screens/add_printer_test.dart';
import 'package:sjekk_application/presentation/screens/printer_details_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../data/models/printer_model.dart';
import 'add_printer_screen.dart';

class PrintersSettings extends StatefulWidget {
  const PrintersSettings({Key? key}) : super(key: key);

  @override
  State<PrintersSettings> createState() => _PrintersSettingsState();
}

class _PrintersSettingsState extends State<PrintersSettings> {
  @override
  void initState() {
    super.initState();
    initializePrinters();
  }

  void initializePrinters() async{
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      final printerProvider = Provider.of<PrinterProvider>(context, listen: false);
      await printerProvider.fetchPrinters();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Consumer<PrinterProvider>(
        builder: (BuildContext context, PrinterProvider value, Widget? child) { 
          if(value.loadingState){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
    
          if(value.errorState){
            return Center(
              child: Text(value.errorMessage),
            );
          }
    
    
    
          return Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TemplateButtonWithIcon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPrinterTest()),
                    ).then((x){
                      value.update();
                    });
                  },
                  icon: Icons.add,
                  backgroundColor: Colors.amber,
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  text: 'Test add with no scan',
                ),
                SizedBox(width: 12.0,),
    
                TemplateButtonWithIcon(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => AddPrinterScreen()),
                    // );
                  },
                  icon: Icons.add,
                  text: 'Add',
                ),
              ],
            ),
            SizedBox(height: 20),
                      if(value.printers.isEmpty)
      Center(
        child: Text('No Printers Available',style: TextStyle(
          color: ThemeHelper.textColor,
          fontSize: 24
        ),),
      ),
    
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.printers.length,
              itemBuilder: (context, index) {
                return PrinterCard(printer: value.printers[index]);
              },
            ),
          ],
        ),
      );
        },
      ),
    );
  }
}

class PrinterCard extends StatelessWidget {
  final Printer printer;

  PrinterCard({required this.printer});

  @override
  Widget build(BuildContext context) {
    return Container(
    color: Colors.black12,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          Icons.print,
          size: 30,
        ),
        title: Text(
          printer.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(printer.address),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: ThemeHelper.secondaryColor,
        ),
        onTap: () {
                              Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PrinterDetailsScreen(printer: printer))
                    );
        },
      ),
    );
  }
}

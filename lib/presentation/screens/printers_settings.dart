import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/presentation/providers/printer_provider.dart';
import 'package:sjekk_application/presentation/screens/add_printer_test.dart';
import 'package:sjekk_application/presentation/screens/printer_details_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../data/models/printer_model.dart';
import 'add_printer_screen.dart';

class PrintersSettings extends StatefulWidget {
  static const String route = 'printers_list';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Consumer<PrinterProvider>(
          builder: (BuildContext context, PrinterProvider value, Widget? child) { 
            // if(value.loadingState){
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
      
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TemplateButtonWithIcon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPrinterTest()),
                      );
                    },
                    icon: Icons.add,
                    backgroundColor: Colors.amber,
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    text: 'TEST CREATE',
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
                    text: 'CREATE',
                  ),
                ],
              ),
              12.h,
        if(value.printers.isEmpty)
        Expanded(
          child: Center(
            child: Text('No Printers Available',style: TextStyle(
              // color: ThemeHelper.textColor,
              fontSize: 24
            ),),
          ),
        ),
      
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: value.printers.length,
                itemBuilder: (context, index) {
                  return TemplateTileContainerCardWithIcon(
                    icon: Icons.print, 
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PrinterDetailsScreen(printer: value.printers[index]))
                      );
                    },
                    title: '${value.printers[index].name} - ${value.printers[index].address}'
                  );
                },
              ),
            ],
          ),
        );
          },
        ),
      ),
    );
  }
}

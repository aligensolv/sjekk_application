import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/presentation/providers/shift_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_dialog.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../providers/auth_provider.dart';

class DoneShiftScreen extends StatelessWidget {
  static const String route = 'done_shift';

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("dd HH:mm");

    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Container(
          color: Colors.grey.shade200, // Use a subtle background color
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.question_mark,
                size: 100.0,
                color: textColor,
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: TemplateHeaderText(
                  'Confirm Shift End',
                ),
              ),
              SizedBox(height: 32.0),
              Center(child: Text('Start Date: ${format.format(
                DateTime.parse(context.read<ShiftProvider>().shift!.startDate)
              )}',style: TextStyle(
                fontSize: 18
              ),)),
              SizedBox(height: 32.0),
              DangerTemplateButton(
                onPressed: () => _showConfirmationDialog(context),
                text: 'END SHIFT',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TemplateConfirmationDialog(
          onConfirmation: (){
            Provider.of<AuthProvider>(context, listen: false).clearAuthenticationState();
            Navigator.of(context).pop(); // Close the dialog
          }, 
          title: 'CONFIRMATION', 
          message: 'Confirm end shift'
        );
      },
    );
  }
}

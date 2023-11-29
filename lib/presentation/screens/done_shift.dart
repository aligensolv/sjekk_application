import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/presentation/providers/shift_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_dialog.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../providers/auth_provider.dart';

class DoneShiftScreen extends StatelessWidget {
  static const String route = 'done_shift';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Container(
        color: Colors.grey.shade200, // Use a subtle background color
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.question_mark,
              size: 100.0,
              color: ThemeHelper.textColor,
            ),
            SizedBox(height: 16.0),
            Text(
              'Confirm Shift End',
              style: Theme.of(context).textTheme.headline5?.copyWith(color: ThemeHelper.textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),
            Center(child: Text('Start Date: ${ShiftProvider.instance.shift!.startDate}',style: TextStyle(
              fontSize: 18
            ),)),
            SizedBox(height: 32.0),
            DangerTemplateButton(
              onPressed: () => _showConfirmationDialog(context),
              text: 'End Shift',
            ),
          ],
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
          title: 'Confirmation', 
          message: 'Confirm end shift'
        );
      },
    );
  }
}
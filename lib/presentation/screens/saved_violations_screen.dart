import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/saved_violation.dart';

import 'violation_details_screen.dart';


class SavedViolationScreen extends StatefulWidget {
  static const String route = 'saved_violations';
  @override
  State<SavedViolationScreen> createState() => _SavedViolationsScreenState();
}

class _SavedViolationsScreenState extends State<SavedViolationScreen> {
  @override
  void initState() {
    super.initState();
    initializeSavedViolations();
  }

  void initializeSavedViolations() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      final violationProvider = Provider.of<ViolationProvider>(context, listen: false);
      await violationProvider.fetchSavedViolations();

    if (violationProvider.errorState) {
      if(mounted){
        SnackbarUtils.showSnackbar(context, violationProvider.errorMessage,
          type: SnackBarType.failure);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Consumer<ViolationProvider>(
          builder: (BuildContext context, ViolationProvider value, Widget? child) {
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
    
            if(value.savedViolations.isEmpty){
              return Center(
                child: Text('no saved violations yet',style: TextStyle(
                  color: ThemeHelper.textColor,
                  fontSize: 24
                ),),
              );
            }
    
            List<Violation> violations = value.savedViolations;
    
            return Container(
              padding: const EdgeInsets.all(12.0),
              child: ListView.separated(
                separatorBuilder: (context,index){
                  return SizedBox(height: 12.0,);
                },
                itemCount: violations.length,
                itemBuilder: (context, index) {
                    Violation violation = violations[index];
              
                    return SavedViolationWidget(
                      violation: violation
                    );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

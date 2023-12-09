import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/completed_violation.dart';


class CompletedViolationsScreen extends StatefulWidget {
  static const String route = 'completed_violations';

  const CompletedViolationsScreen({super.key});
  @override
  State<CompletedViolationsScreen> createState() => _CompletedViolationsScreenState();
}

class _CompletedViolationsScreenState extends State<CompletedViolationsScreen> {
  @override
  void initState() {
    super.initState();
    initializeCompletedViolations();
  }

  void initializeCompletedViolations() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      final violationProvider = Provider.of<ViolationProvider>(context, listen: false);
      await violationProvider.fetchCompletedViolations();

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
    return Scaffold(
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

          if(value.completedViolations.isEmpty){
            return Center(
              child: Text('no completed violations',style: TextStyle(
                color: textColor,
                fontSize: 24
              ),),
            );
          }
          List<Violation> violations = value.completedViolations;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.separated(
              itemCount: violations.length,
              itemBuilder: (context, index) {
                Violation violation = violations[index];
          
                return CompletedViolationWidget(violation: violation);
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 12.0,);
              },
            ),
          );
        },
      ),
    );
  }
}

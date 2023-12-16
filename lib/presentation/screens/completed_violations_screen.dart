import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/screens/completed_violation_brief_information.dart';
import 'package:sjekk_application/presentation/screens/completed_violation_images.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/completed_violation.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/empty_data_container.dart';

import '../widgets/template/components/template_option.dart';
import '../widgets/template/components/template_options_menu.dart';
import '../widgets/template/widgets/place_registered_vl.dart';


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

      OverlayEntry? entry;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: (){
          entry?.remove();
          entry = null;
          
        },
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
          
              if(value.completedViolations.isEmpty){
                return EmptyDataContainer(
                  text: 'No completed violations',
                );
              }
              List<Violation> violations = value.completedViolations;
          
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.separated(
                  itemCount: violations.length,
                  itemBuilder: (context, index) {
                    Violation violation = violations[index];
              
                    return GestureDetector(
                                                onLongPress: (){
              if(entry?.mounted ?? false){
                entry?.remove();
              }
        
                entry = OverlayEntry(
                builder: (context){
                  return TemplateOptionsMenu(
                  headerText: 'OPTIONS',
                  headerColor: Colors.black.withOpacity(0.7),
                  options: [
                    TemplateOption(
                      text: 'PRINT', 
                      backgroundColor: primaryColor,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      icon: Icons.print, 
                      onTap: () async{

                      }
                    ),
                    TemplateOption(
                      text: 'INFORMATION', 
                      backgroundColor: secondaryColor,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      icon: Icons.info_outline, 
                      onTap: () async{
                        entry?.remove();
                        entry = null;
                        Navigator.of(context).pushNamed(
                          CompletedViolationBriefInformation.route,
                          arguments: {
                            'violation': violations[index]
                          }
                        );
                      }
                    ),
                    TemplateOption(
                      text: 'ADD IMAGE', 
                      backgroundColor: scaffoldColor,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      icon: Icons.image, 
                      onTap: () async{
                        context.read<ViolationDetailsProvider>().setViolation(
                          violation
                        );

                        entry?.remove();
                        entry = null;

                        Navigator.of(context).pushNamed(
                          CompletedViolationImages.route
                        );
                      }
                    ),
                    TemplateOption(
                      text: 'BACK', 
                      icon: Icons.redo, 
                      onTap: () async{
                        entry?.remove();
                        entry = null;
                      }
                    ),
                  ],
                );
                }
              );
        
        
            Overlay.of(context).insert(
              entry!
            );
            },
                      child: PlaceRegisteredVL(vl: violation)
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 12.0,);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

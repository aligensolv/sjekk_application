import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/empty_data_container.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/place_registered_vl.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/saved_violation.dart';

import '../../data/repositories/remote/violation_repository.dart';
import '../widgets/template/components/template_option.dart';
import '../widgets/template/components/template_options_menu.dart';


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

    OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        entry?.remove();
        entry = null;
      },
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Consumer<ViolationProvider>(
          builder: (BuildContext context, ViolationProvider value, Widget? child) {
            if(value.loadingState){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
      
            if(value.errorState){
              return Center(
                child: Text(value.errorMessage),
              );
            }
      
            if(value.savedViolations.isEmpty){
              return EmptyDataContainer(
                text: 'No saved violations',
              );
            }
      
            List<Violation> violations = value.savedViolations;
      
            return Container(
              padding: const EdgeInsets.all(12.0),
              child: ListView.separated(
                separatorBuilder: (context,index){
                  return const SizedBox(height: 12.0,);
                },
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
                  text: 'DELETE', 
                  icon: Icons.close, 
                  iconColor: dangerColor,
                  textColor: dangerColor,
                  onTap: () async{
                    ViolationRepositoryImpl vil = ViolationRepositoryImpl();
                    await vil.deleteViolation(violation);

                    entry?.remove();
                    entry = null;

                    initializeSavedViolations();
                  },
                ),
                TemplateOption(
                  text: 'COPY', 
                  icon: Icons.copy, 
                  onTap: () async{
                    ViolationRepositoryImpl vli = ViolationRepositoryImpl();
                    await vli.copyViolation(
                      violations[index],
                      placeLoginTime: context.read<PlaceProvider>().startTime?.toLocal().toString()
                    );
                    entry?.remove();
                    entry = null;

                    initializeSavedViolations();
                    // await Provider.of<CreateViolationProvider>(context,listen: false).setSavedViolation(
                    // s_violation: violation,
                    //   place: context.read<PlaceProvider>().selectedPlace
                    // );
                    //     Violation? savedViolation = await Provider.of<CreateViolationProvider>(context, listen: false).saveViolation();
                    //     if(savedViolation != null){
                    //   SnackbarUtils.showSnackbar(context, 'VL was saved', type: SnackBarType.info);
                    //   Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(savedViolation);
                    //   entry?.remove();
                    //   Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: savedViolation)),
                    //     (route) => route.settings.name == PlaceHome.route
                    //   );
                    //   // Navigator.of(context).popUntil(ModalRoute.withName(PlaceHome.route));
                    // }else{
                    //   SnackbarUtils.showSnackbar(context, Provider.of<CreateViolationProvider>(context, listen: false).errorMessage);
                    // }
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
                      child: SavedViolationWidget(
                        violation: violation
                      ),
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

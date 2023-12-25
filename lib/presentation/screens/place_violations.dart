import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/data/repositories/remote/violation_repository.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/screens/completed_violation_brief_information.dart';
import 'package:sjekk_application/presentation/screens/completed_violation_images.dart';
import 'package:sjekk_application/presentation/screens/completed_violations_details_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/completed_violation.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/empty_data_container.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/place_registered_vl.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/saved_violation.dart';

import '../../core/utils/snackbar_utils.dart';
import '../providers/create_violation_provider.dart';
import '../providers/place_provider.dart';
import '../providers/violation_details_provider.dart';
import '../widgets/template/components/template_option.dart';
import '../widgets/template/components/template_options_menu.dart';
import 'place_home.dart';
import 'violation_details_screen.dart';

class PlaceViolations extends StatefulWidget {
  static const String route = "place_violations";
  final String placeId;

  const PlaceViolations({Key? key, required this.placeId}) : super(key: key);

  @override
  State<PlaceViolations> createState() => _PlaceViolationsState();
}

class _PlaceViolationsState extends State<PlaceViolations> {
  @override
  void initState() {
    super.initState();
    initializeSavedPlaceViolations();
    initializeCompletedPlaceViolations();
  }

  void initializeSavedPlaceViolations() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final violationProvider = context.read<ViolationProvider>();
      await violationProvider.fetchPlaceSavedViolations(widget.placeId);
    });
  }

  void initializeCompletedPlaceViolations() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final violationProvider = context.read<ViolationProvider>();
      await violationProvider.fetchPlaceCompletedViolations(widget.placeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: GestureDetector(
          onTap: (){
          entry?.remove();
          entry = null;
        },
          child: Scaffold(
            backgroundColor: scaffoldColor,
            body: Consumer<ViolationProvider>(
              builder: (BuildContext context, ViolationProvider value,
                  Widget? child) {
                if (value.loadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
            
                if (value.errorState) {
                  return Center(
                    child: AutoSizeText(
                      value.errorMessage,
                      style: TextStyle(
                        fontSize: 24,
                        color: dangerColor,
                      ),
                      maxLines: 1,
                    ),
                  );
                }
            
                if (value.currentPlaceSavedViolations.isEmpty && value.currentPlaceCompletedViolations.isEmpty) {
                  return EmptyDataContainer(
                    text: 'No Violations',
                  );
                }
            
                List<Violation> savedViolations = value.currentPlaceSavedViolations;
                List<Violation> completedViolations = value.currentPlaceCompletedViolations;
                return Column(
                  children: [
                    TabBar(
                      tabs: [
                      Tab(
                    text: 'Saved',
                  ),
                      Tab(
                    text: 'Completed',
                  ),
                      ],
                    ),
        
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TabBarView(
                          children: [
                            savedViolations.isEmpty ? 
                            EmptyDataContainer(text: 'No Saved VL') : _buildSavedViolations(savedViolations),
                            completedViolations.isEmpty ?
                            EmptyDataContainer(text: 'No Completed VL',) : _buildCompletedViolations(completedViolations),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry? entry;

  Widget _buildSavedViolations(List<Violation> violations){
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(height: 12,);
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
                text: 'COPY', 
                icon: Icons.copy, 
                textColor: secondaryColor,
                iconColor: secondaryColor,
                
                onTap: () async{
                  ViolationRepositoryImpl vli = ViolationRepositoryImpl();
                  await vli.copyViolation(
                    violation,
                    placeLoginTime: context.read<PlaceProvider>().startTime?.toLocal().toString()
                  );
                  entry?.remove();
                    entry = null;
                  initializeSavedPlaceViolations();

                }
              ),

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

                    initializeSavedPlaceViolations();
                  },
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
          child: SavedViolationWidget(violation: violation)
        );
      },
    );
  }

  Widget _buildCompletedViolations(List<Violation> violations){
    return Container(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 12,);
                    },
                    itemCount: violations.length,
                    itemBuilder: (context, index) {
                      Violation violation = violations[index];
                
                      return GestureDetector(
                                                                        onTap: (){
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
                      text: 'PRINT', 
                      backgroundColor: primaryColor,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      icon: Icons.print, 
                      onTap: () async{

                      }
                    ),
                    TemplateOption(
                      text: 'FULL DATA', 
                      backgroundColor: secondaryColor,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      icon: Icons.data_object, 
                      onTap: () async{
                        entry?.remove();
                        entry = null;

                        Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(violation);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CompletedViolationDetailsScreen(violation: violation,)
                          )
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
                        child: CompletedViolationWidget(violation: violation)
                      );
                    },
                  ),
                );
  }
}

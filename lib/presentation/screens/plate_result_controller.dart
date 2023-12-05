import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/presentation/providers/create_violation_provider.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/providers/rule_provider.dart';
import 'package:sjekk_application/presentation/screens/plate_result_info.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../core/utils/snackbar_utils.dart';
import '../../data/models/violation_model.dart';
import '../providers/local_violation_details_provider.dart';
import '../providers/violation_details_provider.dart';
import '../widgets/template/components/template_dialog.dart';
import 'local_violation_details.dart';
import 'place_home.dart';
import 'violation_details_screen.dart';

class PlateResultController extends StatelessWidget {
  const PlateResultController({super.key});

  @override
  Widget build(BuildContext context) {
    Place? currentPlace = Provider.of<PlaceProvider>(context, listen: false).selectedPlace;

    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Consumer<CreateViolationProvider>(
        builder: (BuildContext context, CreateViolationProvider createViolationProvider, Widget? child) { 
          if(createViolationProvider.plateInfo == null) {
            return Center(
              child: TemplateParagraphText('Failed to get plate info'),
            );
          }

          if(createViolationProvider.registeredCar != null) {
            return RegisteredCarWidget(
              registeredCar: createViolationProvider.registeredCar!,
              plateInfo: createViolationProvider.plateInfo!,
              place: currentPlace,
            );
          }else{
            return _UnknownCarWidget();
          }
        },
      ),
    );
  }

  Widget _UnknownCarWidget() {
    return Center(
      child: TemplateHeadlineText('Unknown'),
    );
  }
}

class RegisteredCarWidget extends StatelessWidget {
  const RegisteredCarWidget({
    super.key,
    required this.registeredCar,
    required this.plateInfo,
    required this.place
  });

  final RegisteredCar registeredCar;
  final PlateInfo plateInfo;
  final Place? place;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          12.h,
          Image.asset(
            AppImages.cars[plateInfo.brand]
          ),
          TemplateContainerCard(
            title: registeredCar.boardNumber.toString(),
            widthFactor: 0.9,
            fontSize: 36,
          ),
          12.h,
          const TemplateHeadlineText('Sjekk Parking'),
          12.h,
          TemplateParagraphText('Fra: ${registeredCar.startDate}'),
          12.h,
          TemplateParagraphText('Fra: ${registeredCar.endDate}'),
          12.h,
          TemplateParagraphText(
            place?.code ?? 'N/A'
          ),
          12.h,
          TemplateParagraphText(
            place?.location ?? 'N/A'
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: NormalTemplateButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlateResultInfo(
                            plateInfo: plateInfo,
                            place: place,
                            registeredCar: registeredCar,
                          )
                        )
                      );
                    },
                    text: 'INFO',
                  ),
                ),
                12.w,
                Expanded(
                  child: InfoTemplateButton(
                    onPressed: () async{
                      final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
                      await Provider.of<CreateViolationProvider>(context,listen: false).setSavedViolation(
                        plateInfo,
                        placeProvider.selectedPlace!
                      );
                      Violation? savedViolation = await Provider.of<CreateViolationProvider>(context, listen: false).saveViolation();
                      if(savedViolation != null){
                        // await showDialog(
                        //   context: context,
                        //   builder: (context){
                        //     return TemplateSuccessDialog(
                        //       title: 'Saving VL', 
                        //       message: 'VL was saved'
                        //     );
                        //   }
                        // );
                    SnackbarUtils.showSnackbar(context, 'VL was saved', type: SnackBarType.info);
                    Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(savedViolation);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: savedViolation)),
                      (route) => route.settings.name == PlaceHome.route
                    );
                    // Navigator.of(context).popUntil(ModalRoute.withName(PlaceHome.route));
                  }else{
                    SnackbarUtils.showSnackbar(context, Provider.of<CreateViolationProvider>(context, listen: false).errorMessage);
                  }
                    },
                    text: 'LARGE',
                  ),
                ),
                12.w,
                Expanded(
                  child: NormalTemplateButton(
                    onPressed: () async{
        //                       'plate_info': jsonEncode(createViolationProvider.plateInfo!.toJson()),
        // 'registered_car_info': createViolationProvider.registeredCar == null ? 
        //   'null' : jsonEncode(createViolationProvider.registeredCar!.toJson()),
        // 'status': 'saved',
        // 'rules': jsonEncode(ruleProvider.selected),
        // 'place': placeProvider.selectedPlace!.id,
        // 'paper_comment': createViolationProvider.paper_comment,
        // 'out_comment': createViolationProvider.out_comment,
        // 'is_car_registered': jsonEncode(createViolationProvider.isRegistered)
                      // CreateViolationProvider createViolationProvider = Provider.of<CreateViolationProvider>(context, listen: false);
                      // PlaceProvider placeProvider = Provider.of<PlaceProvider>(context, listen: false);
                      // RuleProvider ruleProvider = Provider.of<RuleProvider>(context, listen: false);
                      Violation? violation = Violation(
                        rules: [], 
                        status: 'LOCAL', 
                        createdAt: DateTime.now().toLocal().toString(),
                        plateInfo: plateInfo, 
                        carImages: [], 
                        place: place!, 
                        paperComment: '', 
                        outComment: '', 
                        is_car_registered: true, 
                        registeredCar: registeredCar, 
                        completedAt: null
                      );
                      Provider.of<ViolationDetailsProvider>(context,listen: false).setViolation(violation);
                      Provider.of<LocalViolationDetailsProvider>(context,listen: false).storeLocalViolationCopy(violation);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LocalViolationDetailsScreen(violation: violation)),
                        (route) => route.settings.name == PlaceHome.route
                      );
                  //     Violation? savedViolation = await Provider.of<CreateViolationProvider>(context, listen: false).saveViolation(context);
                  //     if(savedViolation != null){
                  //       // await showDialog(
                  //       //   context: context,
                  //       //   builder: (context){
                  //       //     return TemplateSuccessDialog(
                  //       //       title: 'Saving VL', 
                  //       //       message: 'VL was saved'
                  //       //     );
                  //       //   }
                  //       // );
                  //   Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(savedViolation);
                  //   Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: savedViolation)),
                  //     (route) => route.settings.name == PlaceHome.route
                  //   );
                  //   // Navigator.of(context).popUntil(ModalRoute.withName(PlaceHome.route));
                  // }else{
                  //   SnackbarUtils.showSnackbar(context, Provider.of<CreateViolationProvider>(context, listen: false).errorMessage);
                  // }
                    },
                    text: 'OPPRETT',
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
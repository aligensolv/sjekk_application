import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/presentation/screens/plate_keyboard_input.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../providers/create_violation_provider.dart';
import '../widgets/template/components/template_container.dart';
import 'plate_result_controller.dart';

class ChoosePlateInputScreen extends StatelessWidget {
  static const String route = "/ChoosePlateInput";
  const ChoosePlateInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TemplateHeadlineText('Choose How to input plate number'),
              12.h,
              Row(
                children: [
                  Expanded(
                child: TemplateContainerCardWithIcon(
                  // widthFactor: 0.8,
                  height: 160,
                  title: 'SCAN',backgroundColor: primaryColor, icon: Icons.camera, onTap: () async{
                    var config = LicensePlateScannerConfiguration(
                    topBarBackgroundColor: primaryColor,  
                    scanStrategy: LicensePlateScanStrategy.ML_BASED,
                    cameraModule: CameraModule.BACK,
                    
                    confirmationDialogAccentColor: Colors.green);
                    LicensePlateScanResult result = await ScanbotSdkUi.startLicensePlateScanner(config);
                    if(result.operationResult == OperationResult.CANCELED || result.operationResult == OperationResult.ERROR){
                      return;
                    }

                    final createViolationProvider = context.read<CreateViolationProvider>();
      
                    await createViolationProvider.getCarInfo(result.licensePlate); 
                    await createViolationProvider.getSystemCar(result.licensePlate);
                    
                    if(createViolationProvider.plateInfo != null){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PlateResultController()
                        )
                      );
                    }else{
                      SnackbarUtils.showSnackbar(
                        context, 
                        'Could not found this plate number'
                      );
                    }
                }),
              ),
              12.w,
              Expanded(
                child: TemplateContainerCardWithIcon(
                  height: 160,
                  // widthFactor: 0.8,
                  title: 'KEYBOARD',backgroundColor: secondaryColor, icon: Icons.keyboard, onTap: () {
                    // Navigator.pushNamed(context, CompletedViolationsScreen.route);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PlateKeyboardInputScreen())
                    );
                }),
              )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
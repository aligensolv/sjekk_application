import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scanbot_sdk/license_plate_scan_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/cars_screen.dart';
import 'package:sjekk_application/presentation/screens/create_violation_screen.dart';
import 'package:sjekk_application/presentation/screens/home_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/home_screen.dart';
import 'package:sjekk_application/presentation/screens/place_violations.dart';
import 'package:sjekk_application/presentation/screens/plate_result_controller.dart';
import 'package:sjekk_application/presentation/screens/qrcode_scanner.dart';
import 'package:sjekk_application/presentation/widgets/place_home_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_dialog.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../providers/create_violation_provider.dart';

class PlaceHome extends StatelessWidget {
  static const String route = 'place_home';
  final Place place;
  const PlaceHome({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);
    DateFormat format = DateFormat('HH:mm:ss');
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            32.h,
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () async{
                  bool ok = await showDialog(
                    context: context, 
                    builder: (context){
                      return TemplateConfirmationDialog(
                        onConfirmation: (){
                          Provider.of<PlaceProvider>(context, listen: false).logoutFromCurrentPlace();
                          Navigator.pop(context,true);
                          // Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => route.isFirst);
                        }, 
                        title: 'Signout', 
                        message: 'Do you want to sign out from ${place.location}'
                      );
                    }
                  );

                  if(ok){
                    Navigator.popUntil(
                        context, 
                        (route) => route.settings.name == BottomScreenNavigator.route
                      );
                  }
                },
                child: Icon(Icons.logout,size: 30,color: Colors.red,),
              ),
            ),
            SizedBox(height: 24.0,),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(place.location,style: TextStyle(
                  fontSize: 24,
                  color: ThemeHelper.textColor
                ),),
                20.w,
                Icon(Icons.horizontal_rule),
                20.w,
                            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(format.format(placeProvider.startTime!),style: TextStyle(
                  fontSize: 24.0,
                  color: ThemeHelper.textColor
                ),),
                12.w,
                GestureDetector(
                  onTap: (){
                    Provider.of<PlaceProvider>(context, listen: false).restartStartTime();
                  },
                  child: Icon(Icons.restart_alt,size: 30,),
                )
              ],
            ),
              ],
            ),
                        SizedBox(height: 24,),

            TemplateTileContainerCardWithIcon(
              icon: Icons.add,
              widthFactor: 0.9, 
              onTap: () async{
                var config = LicensePlateScannerConfiguration(
                topBarBackgroundColor: ThemeHelper.primaryColor,  
                scanStrategy: LicensePlateScanStrategy.ML_BASED,
                cameraModule: CameraModule.BACK,
                
                confirmationDialogAccentColor: Colors.green);
                LicensePlateScanResult result = await ScanbotSdkUi.startLicensePlateScanner(config);
                if(result.operationResult == OperationResult.CANCELED || result.operationResult == OperationResult.ERROR){
                  return;
                }

                await Provider.of<CreateViolationProvider>(context, listen: false).getCarInfo(result.licensePlate); 
                await Provider.of<CreateViolationProvider>(context, listen: false).getSystemCar(result.licensePlate);
                
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlateResultController()
                  )
                );
                // Navigator.pushNamed(context, CreateViolationScreen.route);
              },
              title: 'CREATE VL'
            ),
            SizedBox(height: 12,),
            TemplateTileContainerCardWithIcon(
              title: 'REGISTERED CARS',
              icon: FontAwesome.car,
              widthFactor: 0.9,
              onTap: (){
                Navigator.pushNamed(context, BoardsScreen.route);
              }
            ),
      
            SizedBox(height: 12,),
            TemplateTileContainerCardWithIcon(
              title: 'OBSERVED LIST',
              widthFactor: 0.9,
              icon: Icons.list,
              onTap: (){
                Navigator.pushNamed(context, PlaceViolations.route,arguments: {
                  'id': place.id
                });
              }
            ),

            24.h,
            TemplateHeadlineText('MORE FEATUERS'),
            24.h,
            TemplateTileContainerCardWithIcon(
              title: 'SCAN QR',
              icon: Icons.qr_code_scanner_sharp,
              widthFactor: 0.9,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: ((context) =>  QrCodeScanner())));
              }
            ),
      
          ],
        ),
      ),
    );
  }
}
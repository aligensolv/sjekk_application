import 'package:flutter/material.dart';
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
import 'package:sjekk_application/presentation/screens/qrcode_scanner.dart';
import 'package:sjekk_application/presentation/widgets/place_home_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_dialog.dart';
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
                  await showDialog(
                    context: context, 
                    builder: (context){
                      return TemplateConfirmationDialog(
                        onConfirmation: (){
                          Provider.of<PlaceProvider>(context, listen: false).logoutFromCurrentPlace();
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => route.isFirst);
                        }, 
                        title: 'Signout', 
                        message: 'Do you want to sign out from ${place.location}'
                      );
                    }
                  );
                },
                child: Icon(Icons.logout,size: 30,color: Colors.red,),
              ),
            ),
            SizedBox(height: 24.0,),
      
            Text(place.location,style: TextStyle(
              fontSize: 24,
              color: ThemeHelper.textColor
            ),),
            SizedBox(height: 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(format.format(placeProvider.startTime!),style: TextStyle(
                  fontSize: 24.0,
                  color: ThemeHelper.textColor
                ),),
                SizedBox(width: 24.0,),
                GestureDetector(
                  onTap: (){
                    Provider.of<PlaceProvider>(context, listen: false).restartStartTime();
                  },
                  child: Icon(Icons.restart_alt,size: 30,),
                )
              ],
            ),
      
            SizedBox(height: 24,),
            TemplateContainerCardWithIcon(
              title: 'Sjekk',
              icon: Icons.car_crash,
              widthFactor: 0.9,
              onTap: (){
                Navigator.pushNamed(context, BoardsScreen.route);
              }
            ),
      
            SizedBox(height: 12,),
            TemplateContainerCardWithIcon(
              title: 'Scan',
              icon: Icons.qr_code_scanner_sharp,
              widthFactor: 0.9,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: ((context) =>  QrCodeScanner())));
              }
            ),
      
            SizedBox(height: 12,),
            TemplateContainerCardWithIcon(
              title: 'Observed',
              widthFactor: 0.9,
              icon: Icons.watch_later,
              onTap: (){
                Navigator.pushNamed(context, PlaceViolations.route,arguments: {
                  'id': place.id
                });
              }
            ),
      
            Spacer(),
      
            InfoTemplateButton(
              onPressed: () async{
                        var config = LicensePlateScannerConfiguration(
                topBarBackgroundColor: ThemeHelper.primaryColor,  
                scanStrategy: LicensePlateScanStrategy.ML_BASED,
                cameraModule: CameraModule.BACK,
                
                confirmationDialogAccentColor: Colors.green);
                LicensePlateScanResult result = await ScanbotSdkUi.startLicensePlateScanner(config);
                await Provider.of<CreateViolationProvider>(context, listen: false).getCarInfo(result.licensePlate); 
                await Provider.of<CreateViolationProvider>(context, listen: false).getSystemCar(result.licensePlate);
                // Navigator.pushNamed(context, CreateViolationScreen.route);
              }, 
              width: double.infinity,
              text: 'Create VL'
            )
          ],
        ),
      ),
    );
  }
}
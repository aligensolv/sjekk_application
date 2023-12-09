import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/cars_screen.dart';
import 'package:sjekk_application/presentation/screens/choose_plate_input.dart';
import 'package:sjekk_application/presentation/screens/place_violations.dart';
import 'package:sjekk_application/presentation/screens/places_screen.dart';
import 'package:sjekk_application/presentation/screens/qrcode_scanner.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_dialog.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

class PlaceHome extends StatefulWidget {
  static const String route = 'place_home';
  const PlaceHome({super.key});

  @override
  State<PlaceHome> createState() => _PlaceHomeState();
}

class _PlaceHomeState extends State<PlaceHome> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future<bool> myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) async{
    print(info.currentRoute(context)!.settings.name);
    if(info.currentRoute(context)!.settings.name != PlaceHome.route){
      return false;
    }
    
    bool shouldLeave = await showDialog(
      context: context, 
      builder: (context){
        return TemplateConfirmationDialog(
          onConfirmation: () async{
            Navigator.pop(context,true);
          }, 
          title: 'SIGN OUT', 
          message: 'Are you sure you want to sign out?'
        );
      }
    );
    if(shouldLeave){
      Provider.of<PlaceProvider>(context, listen: false).logoutFromCurrentPlace();
      Navigator.of(context).popUntil(
        (route) => route.settings.name == PlacesScreen.route
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final PlaceProvider placeProvider = Provider.of<PlaceProvider>(context);
    Place place = placeProvider.selectedPlace!;
    DateFormat format = DateFormat('HH:mm');
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
                          title: 'SIGNOUT', 
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
                  child: const Icon(Icons.logout,size: 30,color: Colors.red,),
                ),
              ),
              const SizedBox(height: 24.0,),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(place.location,style: TextStyle(
                    fontSize: 24,
                    color: textColor
                  ),),
                  20.w,
                  const Icon(Icons.horizontal_rule),
                  20.w,
                              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(format.format(placeProvider.startTime!),style: TextStyle(
                    fontSize: 24.0,
                    color: textColor
                  ),),
                  12.w,
                  GestureDetector(
                    onTap: (){
                      Provider.of<PlaceProvider>(context, listen: false).restartStartTime();
                    },
                    child: const Icon(Icons.restart_alt,size: 30,),
                  )
                ],
              ),
                ],
              ),
              const SizedBox(height: 24,),
    
              TemplateTileContainerCardWithIcon(
                icon: Icons.add,
                widthFactor: 0.9, 
                onTap: () async{
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChoosePlateInputScreen()
                    )
                  );
                  
                },
                title: 'CREATE VL'
              ),
              const SizedBox(height: 12,),
              TemplateTileContainerCardWithIcon(
                title: 'REGISTERED CARS',
                icon: FontAwesome.car,
                widthFactor: 0.9,
                onTap: (){
                  Navigator.pushNamed(context, BoardsScreen.route);
                }
              ),
        
              const SizedBox(height: 12,),
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
                  Navigator.push(context, MaterialPageRoute(builder: ((context) =>  const QrCodeScanner())));
                }
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}
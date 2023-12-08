import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/presentation/screens/place_home.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/string_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../core/utils/snackbar_utils.dart';
import '../../data/models/place_model.dart';
import '../../data/models/violation_model.dart';
import '../providers/create_violation_provider.dart';
import '../providers/local_violation_details_provider.dart';
import '../providers/violation_details_provider.dart';
import '../widgets/template/components/template_dialog.dart';
import 'local_violation_details.dart';
import 'violation_details_screen.dart';

class UnknownPlateResultInfo extends StatelessWidget {
  const UnknownPlateResultInfo({super.key, required this.plateInfo, required this.place});
  final PlateInfo plateInfo;
  final Place? place;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.black45,
                      height: 130,
                      padding: EdgeInsets.all(12.0),
                      child: Icon(FontAwesome.car, size: 30,color: Colors.white,),
                    ),
                    12.w,
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            'Kjoretoyinfo'.toHeadline(),
                            Divider(thickness: 2,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: plateInfo.brand.concat(plateInfo.type).concat(plateInfo.description).toParagraph(),
                                ),
                                12.w,
                                Image.asset(
                                  AppImages.cars[plateInfo.brand],
                                  width: 80,
                                  height: 80,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

                12.h,
                            Container(
                color: Colors.white,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: dangerColor,
                      height: 130,
                      padding: EdgeInsets.all(8.0),
                      child: Icon(FontAwesome.close, size: 36,color: Colors.white,),
                    ),
                    12.w,
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            'ingen gyldig parkering'.toHeadline(),
                            Divider(thickness: 2,),
                            Wrap(
                              children: [
                                TemplateParagraphText('Searched Sjekk and no valid parking was found'),
                                4.h,
                                TemplateParagraphText('Sjekk Team'),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Spacer(),

              Row(
                children: [
                  Expanded(
                    child: InfoTemplateButton(
                      onPressed: (){

                      },
                      text: 'SOK',
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: NormalTemplateButton(
                      onPressed: () async{
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
                        registeredCar: null, 
                        completedAt: null
                      );
                      Provider.of<ViolationDetailsProvider>(context,listen: false).setViolation(violation);
                      Provider.of<LocalViolationDetailsProvider>(context,listen: false).storeLocalViolationCopy(violation);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => LocalViolationDetailsScreen(),
                          settings: RouteSettings(name: LocalViolationDetailsScreen.route)
                        ),
                        (route) => route.settings.name == PlaceHome.route
                      );
                      },
                      text: 'OPPRETT',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
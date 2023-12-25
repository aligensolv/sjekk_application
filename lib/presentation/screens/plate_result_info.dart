import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/core/utils/logger.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/presentation/providers/auth_provider.dart';
import 'package:sjekk_application/presentation/providers/create_violation_provider.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/screens/place_home.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/string_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../core/utils/snackbar_utils.dart';
import '../../data/models/place_model.dart';
import '../../data/models/violation_model.dart';
import '../providers/local_violation_details_provider.dart';
import '../providers/violation_details_provider.dart';
import '../widgets/template/components/template_text.dart';
import 'local_violation_details.dart';
import 'violation_details_screen.dart';

class PlateResultInfo extends StatefulWidget {
  static const String route = 'plate_result_info';

  @override
  State<PlateResultInfo> createState() => _PlateResultInfoState();
}

class _PlateResultInfoState extends State<PlateResultInfo> {
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
    context.read<CreateViolationProvider>().clearAll();
    return false;
  }

  DateFormat formatter = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final PlateInfo plateInfo = context.read<CreateViolationProvider>().plateInfo;
    final Place? place = context.read<PlaceProvider>().selectedPlace;
    final RegisteredCar? registeredCar = context.read<CreateViolationProvider>().registeredCar;
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.black45,
                      height: 130,
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(FontAwesome.car, size: 30,color: Colors.white,),
                    ),
                    12.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          'Kjoretoyinfo'.toHeadline(),
                          const Divider(thickness: 2,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: 
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    plateInfo.plate.toParagraph(),
                                    (plateInfo.type ?? '').toParagraph(),
                                    (plateInfo.description ?? '').toParagraph(),
                                  ],
                                ),
                              ),
                              12.w,
                              if(plateInfo.brand != null)
                              Image.asset(
                                AppImages.cars[plateInfo.brand!.toLowerCase()] ?? AppImages.cars['Unknown'],
                                width: 80,
                                height: 80,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              12.h,
                            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: dangerColor,
                      height: 130,
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(FontAwesome.close, size: 36,color: Colors.white,),
                    ),
                    12.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          'ingen gyldig parkering'.toHeadline(),
                          const Divider(thickness: 2,),
                          Wrap(
                            children: [
                              TemplateParagraphText('Searched Sjekk and no valid parking was found'),
                              4.h,
                              TemplateParagraphText('Sjekk Team'),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              12.h,

              if(registeredCar != null)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: secondaryColor,
                      height: 160,
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(FontAwesome.info, size: 36,color: Colors.white,),
                    ),
                    12.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          'Registered Car Info'.toHeadline(),
                          const Divider(thickness: 2,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TemplateParagraphText('FRA: ${registeredCar.startDate}'),
                              4.h,
                              TemplateParagraphText('TIL: ${registeredCar.endDate}'),
                              4.h,
                              TemplateParagraphText('RANK: ${registeredCar.rank}'),
                              4.h,
                              TemplateParagraphText('TYPE: ${registeredCar.registerationType}'),
                              4.h,
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              12.h,

              if(context.read<CreateViolationProvider>().existingSavedViolation != null)
              GestureDetector(
                onTap: () async{
                  Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(
                    context.read<CreateViolationProvider>().existingSavedViolation!
                  );

                  Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ViolationDetailsScreen())
          );
                },
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: primaryColor,
                        height: 130,
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.saved_search, size: 36,color: Colors.white,),
                      ),
                      12.w,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            'Saved VL Exists'.toHeadline(),
                            const Divider(thickness: 2,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TemplateParagraphText(
                                    formatter.format(
                                      DateTime.parse(context.read<CreateViolationProvider>().existingSavedViolation!.createdAt)
                                    )
                                  ),
                                ),
              
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(Icons.chevron_right, size: 30, color: Colors.black45,),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const Spacer(),
              Row(
              children: [
                Expanded(
                  child: NormalTemplateButton(
                    onPressed: (){
                      
                    },
                    text: 'SEARCH',
                  ),
                ),
                12.w,
                Expanded(
                  child: InfoTemplateButton(
                    onPressed: () async{

                      Violation x_violation = Violation(
                          rules: [], 
                          status: 'saved', 
                          user: context.read<AuthProvider>().user,
                          createdAt: DateTime.now().toLocal().toString(), 
                          placeStartTime: context.read<PlaceProvider>().startTime?.toLocal().toString(),
                          plateInfo: plateInfo, 
                          carImages: [],
                          place: context.read<PlaceProvider>().selectedPlace!, 
                          paperComment: '', 
                          outComment: '', 
                          is_car_registered: registeredCar != null, 
                          registeredCar: registeredCar, 
                          completedAt: null
                        );

                      await Provider.of<CreateViolationProvider>(context,listen: false).setSavedViolation(
                        s_violation: x_violation,
                      );
                    int? id = await Provider.of<CreateViolationProvider>(context, listen: false).saveViolation();
                    x_violation.id = id;

                    await Provider.of<CreateViolationProvider>(context, listen: false).clearAll();

                    
                    
                    SnackbarUtils.showSnackbar(context, 'VL was saved', type: SnackBarType.info);
                    Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(
                      x_violation
                    );
                    
                   if(context.read<CreateViolationProvider>().errorState){
                    SnackbarUtils.showSnackbar(context, context.read<CreateViolationProvider>().errorMessage);
                    return;
                  }

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => ViolationDetailsScreen(

                      )),
                      (route) => route.settings.name == PlaceHome.route
                    );
                    },
                    text: 'LARGE',
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
                        placeStartTime: context.read<PlaceProvider>().startTime?.toLocal().toString(),
                        plateInfo: plateInfo, 
                        carImages: [], 
                        place: place!, 
                        paperComment: '', 
                        outComment: '', 
                        user: context.read<AuthProvider>().user,
                        is_car_registered: registeredCar != null,  
                        registeredCar: registeredCar, 
                        completedAt: null
                      );
                      // Provider.of<ViolationDetailsProvider>(context,listen: false).setViolation(violation);
                      Provider.of<LocalViolationDetailsProvider>(context,listen: false).storeLocalViolationCopy(violation);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        LocalViolationDetailsScreen.route,
                        (route) => route.settings.name == PlaceHome.route
                      );
                    },
                    text: 'OPPRETT',
                    backgroundColor: Colors.green,
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
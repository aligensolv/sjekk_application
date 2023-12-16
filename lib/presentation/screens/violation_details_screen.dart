import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:sjekk_application/core/utils/logger.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/choose_plate_input.dart';
import 'package:sjekk_application/presentation/screens/select_brand_screen.dart';
import 'package:sjekk_application/presentation/screens/select_car_type_screen.dart';
import 'package:sjekk_application/presentation/screens/select_color_screen.dart';
import 'package:sjekk_application/presentation/screens/select_rule_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/rule_container.dart';

import '../../core/utils/router_utils.dart';
import '../../data/models/rule_model.dart';
import '../../data/models/violation_model.dart';
import '../../data/repositories/remote/violation_repository.dart';
import '../providers/create_violation_provider.dart';
import '../providers/rule_provider.dart';
import '../widgets/template/components/template_dialog.dart';
import '../widgets/template/components/template_image.dart';
import '../widgets/template/components/template_option.dart';
import '../widgets/template/components/template_options_menu.dart';
import 'gallery_view.dart';
import 'place_home.dart';

import 'dart:math';
class ViolationDetailsScreen extends StatefulWidget {
  static const String route = 'violation_details_screen';
  // final Violation violation;

  const ViolationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ViolationDetailsScreen> createState() => _ViolationDetailsScreenState();
}

class _ViolationDetailsScreenState extends State<ViolationDetailsScreen> with SingleTickerProviderStateMixin{

  final TextEditingController innerController = TextEditingController();
  final TextEditingController outterController = TextEditingController();
  
  final TextEditingController descriptionController = TextEditingController();
  
  final TextEditingController plateController = TextEditingController();

    Future<bool> violationDetailsBack(bool stopDefaultButtonEvent, RouteInfo info) async{
      context.read<ViolationDetailsProvider>().cancelPrintTimer();
      context.read<CreateViolationProvider>().clearAll();
      if(info.currentRoute(context)!.settings.name != ViolationDetailsScreen.route){
        return false;
      }

      return true;
    }

  void initializeRules() async{
    await Provider.of<RuleProvider>(context, listen: false).fetchRules();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initializeRules();
      pinfo(context.read<ViolationDetailsProvider>().violation.placeStartTime);
      
      BackButtonInterceptor.add(violationDetailsBack);

      context.read<ViolationDetailsProvider>().setSiteLoginTime(
        // context.read<PlaceProvider>().startTime
        DateTime.parse(
          context.read<ViolationDetailsProvider>().violation.placeStartTime ?? ''
        )
      );
      Provider.of<ViolationDetailsProvider>(context, listen: false).updateTimePolicy();

      DateTime parsedCreatedAt = context.read<ViolationDetailsProvider>().siteLoginTime ?? DateTime.now();
      pwarnings(context.read<ViolationDetailsProvider>().siteLoginTime);
      pwarnings(DateTime.now().difference(parsedCreatedAt).inMinutes);
      if(
        context.read<ViolationDetailsProvider>().siteLoginTime != null
        && DateTime.now().difference(parsedCreatedAt).inMinutes <= 6  
      ){
        context.read<ViolationDetailsProvider>().cancelPrintTimer();
              context.read<ViolationDetailsProvider>().setSiteLoginTime(
        // context.read<PlaceProvider>().startTime
        DateTime.parse(
          context.read<ViolationDetailsProvider>().violation.placeStartTime ?? ''
        )
      );

      context.read<ViolationDetailsProvider>().maxTimePolicy = 6;
        context.read<ViolationDetailsProvider>().createPrintTimer();
      }
    });

  final violationDetailsProvider = Provider.of<ViolationDetailsProvider>(context,listen: false);
            innerController.text = violationDetailsProvider.violation.paperComment;
        outterController.text = violationDetailsProvider.violation.outComment;
  }



  @override
  void dispose() {
    BackButtonInterceptor.remove(violationDetailsBack);
    descriptionController.dispose();
    innerController.dispose();
    outterController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        body: Column(
          children: [
            24.h,
            TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.info_outline),
              ),
              Tab(
                icon: Icon(Icons.image),
              ),
              Tab(
                icon: Icon(Icons.rule),
              ),
              Tab(
                icon: Icon(Icons.comment),
              ),
              Tab(
                icon: Icon(Icons.print),
              ),
            ],
          ),
          12.h,
            Expanded(
              child: TabBarView(
                children: [
                  CarInfoWidget(),
                  ImagesWidget(),
                  RulesWidget(),
                  CommentsWidget(),
                  PrintWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CommentsWidget(){
    return Consumer<ViolationDetailsProvider>(
      builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) {  
        return Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalTemplateTextField(
                hintText: 'Inner Comment',
                lines: 5,
                controller: innerController,
              ),
              12.h,
              Align(
                alignment: Alignment.centerRight,
                child: InfoTemplateButton(
                  onPressed: () async{
                    await violationDetailsProvider.changePaperComment(innerController.text);
                    await showDialog(
                      context: context, 
                      builder: (context){
                        return TemplateSuccessDialog(
                          title: 'Saving Comment', 
                          message: 'Inner comment was saved'
                        );
                      }
                    );
                  }, 
                  text: 'SAVE'
                ),
              ),
              12.h,
              NormalTemplateTextField(
                hintText: 'Outter Comment',
                lines: 5,
                controller: outterController,
              ),
              12.h,
              Align(
                alignment: Alignment.centerRight,
                child: InfoTemplateButton(
                  onPressed: () async{
                    await violationDetailsProvider.changeOutComment(outterController.text);
                    await showDialog(
                      context: context, 
                      builder: (context){
                        return TemplateSuccessDialog(
                          title: 'Saving Comment', 
                          message: 'Outter comment was saved'
                        );
                      }
                    );
                  }, 
                  text: 'SAVE'
                ),
              ),
            ],
          ),
        );
      },
    );
  }


Widget CarInfoWidget() {
  final detailsProvider = context.read<ViolationDetailsProvider>();
  DateFormat formatter = DateFormat('HH:mm .dd.MM.yyyy');
  OverlayEntry? entry;


  return Consumer<ViolationDetailsProvider>(
    builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) { 
      return GestureDetector(
    onTap: (){
      if(entry != null){
        entry?.remove();
        entry = null;
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async{
                      await showDialog(
                        context: context, 
                        builder: (context){
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Enter Plate'),
                                GestureDetector(
                                  onTap: () async{
                                    var config = LicensePlateScannerConfiguration(
                                    topBarBackgroundColor: primaryColor,  
                                    scanStrategy: LicensePlateScanStrategy.ML_BASED,
                                    cameraModule: CameraModule.BACK,
                                    
                                    confirmationDialogAccentColor: Colors.green);
                                    LicensePlateScanResult result = await ScanbotSdkUi.startLicensePlateScanner(config);
                                    if(result.operationResult == OperationResult.CANCELED || result.operationResult == OperationResult.ERROR){
                                      return Navigator.pop(context);
                                    }

                                    final createViolationProvider = context.read<CreateViolationProvider>();
      
                                    await createViolationProvider.getCarInfo(result.licensePlate); 
                                    await createViolationProvider.getSystemCar(result.licensePlate);

                                    await violationDetailsProvider.changePlateInfo(
                                      createViolationProvider.plateInfo
                                    );

                                    await violationDetailsProvider.changeRegisterdCarData(
                                      createViolationProvider.registeredCar
                                    );

                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.camera,color: secondaryColor,),
                                )
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero
                            ),
                            content: Container(
                              width: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SecondaryTemplateTextFieldWithIcon(
                                    hintText: 'PLATE',
                                    icon: Icons.search,
                                    controller: plateController,
                                  ),

                                  12.h,

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: NormalTemplateButton(
                                      text: 'OK',
                                      onPressed: () async{
                                        final createViolationProvider = context.read<CreateViolationProvider>();
      
                                        await createViolationProvider.getCarInfo(plateController.text); 
                                        await createViolationProvider.getSystemCar(plateController.text);

                                        await violationDetailsProvider.changePlateInfo(
                                          createViolationProvider.plateInfo
                                        );

                                        await violationDetailsProvider.changeRegisterdCarData(
                                          createViolationProvider.registeredCar
                                        );

                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      );
                    },
                    child: TemplateContainerCard(
                      title: detailsProvider.violation.plateInfo.plate.isEmpty 
                      ? 'N/A' : detailsProvider.violation.plateInfo.plate,
                      height: 40,
                      
                      backgroundColor: detailsProvider.violation.is_car_registered ? Colors.blue : dangerColor, 
                    ),
                  ),
                ),
                12.w,
                DangerTemplateIconButton(
                  onPressed: () async{
                    entry = OverlayEntry(
                      builder: (context){
                        return TemplateConfirmationDialog(
                          onConfirmation: () async{
                            ViolationRepositoryImpl vil = ViolationRepositoryImpl();
                            await vil.deleteViolation(
                              context.read<ViolationDetailsProvider>().violation
                            );

                            entry?.remove();
                            entry = null;

                            Navigator.popUntil(
                              context, 
                              (route) => route.settings.name == PlaceHome.route
                            );
                          }, 
                          onCancel: (){
                            entry?.remove();
                          },
                            title: 'Deleting VL', 
                            message: 'Are you sure you want to delete this VL?'
                          );
  }
                    );
  
                    Overlay.of(context).insert(
                      entry!
                    );
                  }
                ),
              ],
            ),
            12.h,
            _buildInfoContainer(
              'TYPE', 
              detailsProvider.violation.plateInfo.type,
              icon: Icons.category,
              editable: true,
              route: SelectCarTypeScreen.route
            ),
            _buildInfoContainer('STATUS', detailsProvider.violation.status.toUpperCase(), icon: FontAwesome.exclamation),
            _buildInfoContainer(
              'BRAND', 
              detailsProvider.violation.plateInfo.brand,icon: FontAwesome.car,
              editable: true,
              route: SelectCarBrandScreen.route
            ),
            GestureDetector(
              onTap: () async{
                await showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: Text('Select Date'),
                      content: Container(
                        width: 300,
                        height: 300,
                        child: YearPicker(
                        firstDate: DateTime(1990), 
                        lastDate: DateTime(2240), 
                        selectedDate: DateTime(2000), 
                        onChanged: (year) async{
                          await violationDetailsProvider.changeViolationYear(year.year.toString());
                          Navigator.pop(context);
                        }
                        ),
                      ),
                    );
                  }
                );
              },
              child: _buildInfoContainer(
                'YEAR', 
                detailsProvider.violation.plateInfo.year, icon: Icons.calendar_month,
                editable: true
              )
            ),
            GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: Text('Enter Description'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                      ),
                      content: Container(
                        width: 300,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NormalTemplateTextField(
                              lines: 5,
                              controller: descriptionController, 
                              hintText: 'Description',
                            ),
                            12.h,
                            Align(
                              alignment: Alignment.centerRight,
                              child: NormalTemplateButton(
                                onPressed: () async{
                                  await violationDetailsProvider.changeViolationDescription(
                                    descriptionController.text
                                  );
                                  Navigator.pop(context);
                                }, 
                                text: 'OK'
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
              child: _buildInfoContainer(
                'DESCRIPTION',
                detailsProvider.violation.plateInfo.description, 
                icon: Icons.text_fields,
                editable: true
              )
            ),
            _buildInfoContainer(
              'COLOR', 
              detailsProvider.violation.plateInfo.color, icon: Icons.color_lens,
              editable: true,
              route: SelectCarColorScreen.route
            ),
            _buildInfoContainer('CREATED AT', formatter.format(DateTime.parse(detailsProvider.violation.createdAt)), icon: Icons.date_range),
      
            if(detailsProvider.violation.is_car_registered && detailsProvider.violation.registeredCar != null)
            Column(
              children: [
                TemplateHeadlineText('MORE INFORMATION'),
                12.h,
                _buildInfoContainer('RANK', detailsProvider.violation.registeredCar!.rank, icon: Icons.star),
                _buildInfoContainer('REGISTERATION TYPE', detailsProvider.violation.registeredCar!.registerationType, icon: Icons.app_registration),
                _buildInfoContainer('FRA', detailsProvider.violation.registeredCar!.startDate,icon: Icons.start),
                _buildInfoContainer('TIL',  detailsProvider.violation.registeredCar!.endDate, icon: Icons.start)
              ],
            )
          ],
        ),
      ),
    ),
  );
    },
  );
}

Widget _buildInfoContainer(
  String title, 
  String? value, 
  {IconData? icon = Icons.info_outline, bool editable = false, String? route}
) {
  return GestureDetector(
    onTap: editable && route != null ? () async{
      Navigator.of(context).pushNamed(
        route
      );
    } : null,
    child: Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            alignment: Alignment.center,
            child: Icon(icon,size: 30,color: Colors.white,),
            color: primaryColor,
            height:60,
            width: 60,
          ),
          12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                6.h,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value ?? '',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          if(editable)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.swap_horiz),
            ),
          )
        ],
      ),
    ),
  );
}

OverlayEntry? entry;

Widget ImagesWidget(){
  DateFormat format = DateFormat('HH:mm');

  return Consumer<ViolationDetailsProvider>(
    builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) {  
      return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0
                      ),
                      
                        itemCount: violationDetailsProvider.violation.carImages.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onLongPress: () async{
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
                  backgroundColor: dangerColor,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  onTap: () async{
                    await violationDetailsProvider.removeImage(
                      violationDetailsProvider.violation.carImages[index]
                    );
                    // ViolationRepositoryImpl vil = ViolationRepositoryImpl();
                    // await vil.deleteViolation(violation);

                    entry?.remove();
                    entry = null;
                  },
                ),

              TemplateOption(
                text: 'BACK', 
                icon: Icons.redo,
                backgroundColor: Colors.black12,
                iconColor: Colors.white,
                textColor: Colors.white,
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
                          child: Stack(
                            children: [
                              TemplateFileImageContainer(
                                path: violationDetailsProvider.violation.carImages[index].path,
                                onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => TemplateGalleryViewScreen(
                                      images: violationDetailsProvider.violation.carImages, 
                                      initialIndex: index,
                                      gallerySource: GallerySource.file,
                                    ))
                                  );
                                },
                              ),
                        
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  color: Colors.black54,
                                  child: Text(
                                    format.format(
                                      DateTime.parse(violationDetailsProvider.violation.carImages[index].date)
                                    ),
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      
                    ),
        ),
        12.h,

        NormalTemplateButton(
          text: 'ADD IMAGE',
          width: double.infinity,
          backgroundColor: secondaryColor,
          onPressed: () async{
            ImagePicker imagePicker = ImagePicker();
            XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
            if(file != null){
              await violationDetailsProvider.storeImage(file.path);
            }
          },
        )
      ],
    ),
  );
    },
  );
}
OverlayEntry? rulesOverlay;
Widget RulesWidget(){
  return Consumer<ViolationDetailsProvider>(
    builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) { 
      final ruleProvider = context.read<RuleProvider>();

          return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              // itemCount: violationDetailsProvider.violation.rules.length,
              itemCount: ruleProvider.rules.length,
              separatorBuilder: ((context, index) {
                return 12.h;
              }),
              itemBuilder: ((context, index) {
                Rule rule = ruleProvider.rules[index];
                return GestureDetector(
                  onTap: () async{
                    if(violationDetailsProvider.violation.rules.any((element) => element.id == rule.id)){
                      await violationDetailsProvider.deattachRuleToViolation(rule);
                    }else{
                      await violationDetailsProvider.attachRuleToViolation(rule);
                    }
                  },
                                            onLongPress: () async{
                          if(rulesOverlay?.mounted ?? false){
          rulesOverlay?.remove();
        }

          rulesOverlay = OverlayEntry(
          builder: (context){
            return TemplateOptionsMenu(
            headerText: 'OPTIONS',
            headerColor: Colors.black.withOpacity(0.7),
            options: [
                TemplateOption(
                text: 'DELETE', 
                icon: Icons.close, 
                backgroundColor: dangerColor,
                iconColor: Colors.white,
                textColor: Colors.white,
                onTap: () async{
                  await violationDetailsProvider.deattachRuleToViolation(
                    violationDetailsProvider.violation.rules[index]
                  );
                  // ViolationRepositoryImpl vil = ViolationRepositoryImpl();
                  // await vil.deleteViolation(violation);

                  rulesOverlay?.remove();
                  rulesOverlay = null;
                },
                ),

              TemplateOption(
                text: 'BACK', 
                icon: Icons.redo,
                backgroundColor: Colors.black12,
                iconColor: Colors.white,
                textColor: Colors.white,
                onTap: () async{
                rulesOverlay?.remove();
                rulesOverlay = null;
                }
              ),
            ],
          );
          }
        );


      Overlay.of(context).insert(
        rulesOverlay!
      );
                        },
                  child: TemplateContainerCard(
                    backgroundColor: violationDetailsProvider.violation.rules
                      .any((element) => element.id == rule.id) ? primaryColor : Colors.black12,
                      textColor: violationDetailsProvider.violation.rules
                      .any((element) => element.id == rule.id) ? null : Colors.black,
                    title: '${rule.name} (${rule.charge} kr)',
                    // icon: Icons.euro,
                  ),
                );
              }),
            ),
          ),

          // 12.h,
          // NormalTemplateButton(
          //   text: 'ADD RULE',
          //   backgroundColor: violationDetailsProvider.violation.rules
          //   .any((element) => element.id == r),
          //   width: double.infinity,
          //   onPressed: (){
          //     Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => SelectRuleScreen())
          //     );
          //   },
          // )
        ],
      ),
    );
    },
  );
}

Widget PrintWidget(){

  final media = MediaQuery.of(context).size;

  return Consumer<ViolationDetailsProvider>(
    builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) { 
        final provider = Provider.of<ViolationDetailsProvider>(context,listen: false);
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(provider.isTimerActive)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TemplateParagraphText('You Have wait ${provider.maxTimePolicy} minutes before printing'),
                  12.h,
                  TemplateHeadlineText(
                    'Time passed: ${provider.timePassed}'
                  ),
                ],
              ),
              if(provider.isTimerActive)
              24.h,
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: violationDetailsProvider.printOptions.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: () async{
                        await violationDetailsProvider.setSelectedPrintOptionIndex(index);
                      },
                      child: Container(
                                width: media.width * 0.7,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                      color: violationDetailsProvider.selectedPrintOptionIndex == index ? Colors.blue : Colors.black12
                                ),
                                child: Text(
                                  violationDetailsProvider.printOptions[index].name.toUpperCase(),
                                  style: TextStyle(
                                    color: violationDetailsProvider.selectedPrintOptionIndex == index ? Colors.white : Colors.black
                                  ),
                                ),
                              ),
                    );
                  },
                  separatorBuilder: (context,index){
                    return SizedBox(height: 12,);
                  },
                ),
              ),

              Opacity(
                opacity: provider.isTimerActive ? 0.5 : (
                  provider.violation.carImages.isNotEmpty 
                  && provider.violation.rules.isNotEmpty
                  && provider.violation.plateInfo.brand != null ?
                  1 : 0.5
                ),
                child: AbsorbPointer(
                  absorbing: provider.isTimerActive
                  || provider.violation.carImages.isEmpty 
                  || provider.violation.rules.isEmpty
                  || provider.violation.plateInfo.brand == null 
                ,
                  child: NormalTemplateButton(
                    width: double.infinity,
                    backgroundColor: secondaryColor,
                    onPressed: ()async{

                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                      if(file != null){
                        await violationDetailsProvider.storeImage(file.path);
                        SnackbarUtils.showSnackbar(context, 'VL is completed');
                        Navigator.popUntil(context, (route) =>  route.settings.name == PlaceHome.route || route.settings.name == BottomScreenNavigator.route);
                        await Provider.of<ViolationDetailsProvider>(context, listen: false).uploadViolationToServer();

                        ViolationRepositoryImpl vil = ViolationRepositoryImpl();
                          await vil.deleteViolation(violationDetailsProvider.violation);
                        }

                        await context.read<CreateViolationProvider>().clearAll();
                  }, text: 'PRINT',),
                ),
              ),
            ],
          ),
        );
    },
  );
}

}

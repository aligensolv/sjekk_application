import 'dart:async';
import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scanbot_sdk/license_plate_scan_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:sjekk_application/core/utils/router_utils.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/local_select_brand.dart';
import 'package:sjekk_application/presentation/screens/local_select_color.dart';
import 'package:sjekk_application/presentation/screens/select_car_type_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_option.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_options_menu.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import '../../data/models/rule_model.dart';
import '../providers/create_violation_provider.dart';
import '../providers/local_violation_details_provider.dart';
import '../providers/rule_provider.dart';
import '../providers/violation_details_provider.dart';
import '../widgets/template/components/template_dialog.dart';
import '../widgets/template/components/template_image.dart';
import 'gallery_view.dart';
import 'local_select_rule_screen.dart';
import 'local_select_violation_type.dart';
import 'place_home.dart';

enum OptionMenuFlags{
  deleteViolation,
  saveViolation,
  savingError,
  cancel
}

class LocalViolationDetailsScreen extends StatefulWidget {
  static const String route = "local_violation_details_screen";

  // const LocalViolationDetailsScreen({Key? key, required this.violation}) : super(key: key);

  @override
  State<LocalViolationDetailsScreen> createState() => _LocalViolationDetailsScreenState();
}

class _LocalViolationDetailsScreenState extends State<LocalViolationDetailsScreen> {

  TextEditingController innerController = TextEditingController();
  TextEditingController outterController = TextEditingController();

  OverlayEntry? entry;
  
  final TextEditingController plateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<bool> localViolationDetailsBack(bool stopDefaultButtonEvent, RouteInfo info) async{
    if(entry?.mounted ?? false){
      entry?.remove();
      return true;
    }
    print(info.currentRoute(context));
    context.read<LocalViolationDetailsProvider>().cancelPrintTimer();
    if(info.currentRoute(context)!.settings.name != LocalViolationDetailsScreen.route){
      return false;
    }

    entry = OverlayEntry(
        builder: (context){
          return TemplateOptionsMenu(
          headerText: 'OPTIONS',
          headerColor: Colors.black54,
          options: [
            TemplateOption(
              text: 'SAVE', 
              icon: Icons.download, 
              iconColor: Colors.white,
              textColor: Colors.white,
              backgroundColor: secondaryColor,
              onTap: () async{
                final provider = context.read<LocalViolationDetailsProvider>();
                final createProvider = context.read<CreateViolationProvider>();

                Violation vl = provider.localViolationCopy;
                vl.status = 'saved';

                createProvider.setSavedViolation(
                  s_violation: vl,
                );

                await createProvider.saveViolation();

                entry?.remove();
                entry = null;

                SnackbarUtils.showSnackbar(context, 'VL is saved');

                Navigator.of(context).popUntil(
                  (route) => route.settings.name == PlaceHome.route
                );
              }
            ),
            TemplateOption(
              text: 'DELETE', 
              backgroundColor: dangerColor,
              textColor: Colors.white,
              iconColor: Colors.white,
              icon: Icons.close,
              onTap: (){
                entry?.remove();
                Navigator.pop(context);
              }
            ),
            TemplateOption(
              text: 'BACK', 
              icon: Icons.redo,
              backgroundColor: Colors.black12,
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: (){
                entry?.remove();
                // Navigator.pop(context);
              }
            ),
          ],
        );
        }
      );


    Overlay.of(context).insert(
      entry!
    );
    return true;
  }


  void initializeRules() async{
    await Provider.of<RuleProvider>(context, listen: false).fetchRules();
  }
        
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          BackButtonInterceptor.add(localViolationDetailsBack,zIndex: 2,context: context);

    initializeRules();

      // context.read<LocalViolationDetailsProvider>().setSiteLoginTime(
      //   DateTime.parse(
      //     context.read<LocalViolationDetailsProvider>().localViolationCopy.createdAt
      //   )
      // );
      // Provider.of<LocalViolationDetailsProvider>(context, listen: false).updateTimePolicy();
    
  final localViolationDetailsProvider = Provider.of<LocalViolationDetailsProvider>(context, listen: false);
    
        innerController.text = localViolationDetailsProvider.localViolationCopy.paperComment;
        outterController.text = localViolationDetailsProvider.localViolationCopy.outComment;
    });
  }


  @override
  void dispose() {
    BackButtonInterceptor.remove(localViolationDetailsBack);
    plateController.dispose();
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
      child: GestureDetector(
        onTap: (){
          entry?.remove();
          entry = null;

          imageOverLayEntry?.remove();
          imageOverLayEntry = null;
        },
        child: Scaffold(
          body: Column(
            children: [
              24.h,
              const TabBar(
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
                )
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
                    PrintWidget()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PrintWidget(){

  final media = MediaQuery.of(context).size;

  return Consumer<LocalViolationDetailsProvider>(
    builder: (BuildContext context, LocalViolationDetailsProvider violationDetailsProvider, Widget? child) { 
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              NormalTemplateButton(
                width: double.infinity,
                backgroundColor: secondaryColor,
                onPressed: ()async{

                  ImagePicker imagePicker = ImagePicker();
                  XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                  if(file != null){
                    await violationDetailsProvider.pushImage(file.path);
                    SnackbarUtils.showSnackbar(context, 'VL is completed');
                    Navigator.popUntil(context, (route) =>  route.settings.name == PlaceHome.route || route.settings.name == BottomScreenNavigator.route);
                    await Provider.of<LocalViolationDetailsProvider>(context, listen: false).uploadViolationToServer();

                    // ViolationRepositoryImpl vil = ViolationRepositoryImpl();
                    //   await vil.deleteViolation(violationDetailsProvider.violation);
                    }

                    await context.read<CreateViolationProvider>().clearAll();
              }, text: 'PRINT',),
            ],
          ),
        );
    },
  );
}

  Widget CommentsWidget(){
    return Consumer<LocalViolationDetailsProvider>(
      builder: (BuildContext context, LocalViolationDetailsProvider localViolationDetailsProvider, Widget? child) {  
        return Padding(
          padding:  const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalTemplateTextField(
                hintText: 'Inner Comment',
                lines: 5,
                onChanged: (val){
                  innerController.text = val;
                },
              ),
              12.h,
              Align(
                alignment: Alignment.centerRight,
                child: InfoTemplateButton(
                  onPressed: () async{
                    await localViolationDetailsProvider.updateInnerComment(innerController.text);
                    await showDialog(
                      context: context, 
                      builder: (context){
                        return const TemplateSuccessDialog(
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
                onChanged: (val){
                  outterController.text = val;
                },
              ),
              12.h,
              Align(
                alignment: Alignment.centerRight,
                child: InfoTemplateButton(
                  onPressed: () async{
                    await localViolationDetailsProvider.updateOutterComment(outterController.text);
                    await showDialog(
                      context: context, 
                      builder: (context){
                        return const TemplateSuccessDialog(
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
  DateFormat formatter = DateFormat('HH:mm .dd.MM.yyyy');
  return Consumer<LocalViolationDetailsProvider>(
    builder: (BuildContext context, LocalViolationDetailsProvider localViolationDetailsProvider, Widget? child) { 
        return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
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

                                    await localViolationDetailsProvider.changePlateInfo(
                                      createViolationProvider.plateInfo
                                    );

                                    await localViolationDetailsProvider.changeRegisterdCarData(
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

                                        await localViolationDetailsProvider.changePlateInfo(
                                          createViolationProvider.plateInfo
                                        );

                                        await localViolationDetailsProvider.changeRegisterdCarData(
                                          createViolationProvider.registeredCar
                                        );

                                        plateController.clear();

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
              title: context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.plate.isEmpty ?
               'N/A' : context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.plate,
              height: 40,
            
              backgroundColor: context.read<LocalViolationDetailsProvider>().localViolationCopy.is_car_registered ? Colors.blue : dangerColor,
            ),
          ),
          12.w,
          12.h,
          _buildInfoContainer(
            'TYPE', 
            context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.type, icon: Icons.category,
            editable: true,
            route: LocalSelectCarTypeScreen()
          ),
          _buildInfoContainer('STATUS', context.read<LocalViolationDetailsProvider>().localViolationCopy.status.toUpperCase(), icon: FontAwesome.exclamation),
          _buildInfoContainer(
            'BRAND', 
            context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.brand,icon: FontAwesome.car,
            editable: true,
            route: LocalSelectCarBrandScreen()  
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
                          await localViolationDetailsProvider.changeViolationYear(year.year.toString());
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
              context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.year, icon: Icons.calendar_month,
              editable: true,

              
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
                                  await localViolationDetailsProvider.changeViolationDescription(
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
              context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.description, icon: Icons.text_fields,
              editable: true  
            )),
          _buildInfoContainer(
            'COLOR', 
            context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.color, icon: Icons.color_lens,
            editable: true,
            route: LocalSelectCarColorScreen()  
          ),
          _buildInfoContainer('CREATED AT', formatter.format(
            DateTime.parse(context.read<LocalViolationDetailsProvider>().localViolationCopy.createdAt)
          ) , icon: Icons.date_range),
    
          if(context.read<LocalViolationDetailsProvider>().localViolationCopy.is_car_registered && context.read<LocalViolationDetailsProvider>().localViolationCopy.registeredCar != null)
          Column(
            children: [
              TemplateHeadlineText('MORE INFORMATION'),
              12.h,
              _buildInfoContainer('RANK', context.read<LocalViolationDetailsProvider>().localViolationCopy.registeredCar!.rank, icon: Icons.star),
              _buildInfoContainer('REGISTERATION TYPE', context.read<LocalViolationDetailsProvider>().localViolationCopy.registeredCar!.registerationType,icon:  Icons.app_registration),
              _buildInfoContainer('FRA', context.read<LocalViolationDetailsProvider>().localViolationCopy.registeredCar!.startDate, icon: Icons.start),
              _buildInfoContainer('TIL', context.read<LocalViolationDetailsProvider>().localViolationCopy.registeredCar!.endDate, icon: Icons.start)
            ],
          )
        ],
      ),
    ),
  );
    },
  );
}

Widget _buildInfoContainer(
  String title, 
  String? value, 
  {IconData? icon = Icons.info_outline, bool editable = false, Widget? route}
) {
  return GestureDetector(
    onTap: editable && route != null ? () async{
      Navigator.of(context).push(
        buildCustomBuilder(route, RouteSettings())
      );
    } : null,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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

OverlayEntry? imageOverLayEntry;

Widget ImagesWidget(){
    DateFormat format = DateFormat('HH:mm');

  return Consumer<LocalViolationDetailsProvider>(
    builder: (BuildContext context, LocalViolationDetailsProvider localViolationDetailsProvider, Widget? child) {  
      return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0
                      ),
                      
                        itemCount: localViolationDetailsProvider.localViolationCopy.carImages.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onLongPress: () async{
                            if(imageOverLayEntry?.mounted ?? false){
          imageOverLayEntry?.remove();
        }

          imageOverLayEntry = OverlayEntry(
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
                    localViolationDetailsProvider.removeImage(
                      localViolationDetailsProvider.localViolationCopy.carImages[index].id
                    );

                    imageOverLayEntry?.remove();
                    imageOverLayEntry = null;
                  },
                ),

              TemplateOption(
                text: 'BACK', 
                icon: Icons.redo,
                iconColor: Colors.white,
                textColor: Colors.white,
                backgroundColor: Colors.black12,
                onTap: () async{
                  imageOverLayEntry?.remove();
                  imageOverLayEntry = null;
                }
              ),
            ],
          );
          }
        );


      Overlay.of(context).insert(
        imageOverLayEntry!
      );
                          },
                          child: Stack(
                            children: [
                              TemplateFileImageContainer(
                                path: localViolationDetailsProvider.localViolationCopy.carImages[index].path,
                                onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => TemplateGalleryViewScreen(
                                      images: localViolationDetailsProvider.localViolationCopy.carImages, 
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
                                        DateTime.parse(localViolationDetailsProvider.localViolationCopy.carImages[index].date)
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

              await localViolationDetailsProvider.pushImage(file.path);
            }
          },
        )
      ],
    ),
  );
    },
  );
}

Widget RulesWidget(){
  return Consumer<LocalViolationDetailsProvider>(
    builder: (BuildContext context, LocalViolationDetailsProvider localViolationDetailsProvider, Widget? child) { 
      final ruleProvider = context.read<RuleProvider>();

          return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: ruleProvider.rules.length,
              separatorBuilder: (context,index){
                return 12.h;
              },
              itemBuilder: ((context, index) {
                Rule rule = ruleProvider.rules[index];
                return GestureDetector(
                  onTap: () async{
                    if(localViolationDetailsProvider.localViolationCopy.rules.any((element) => element.id == rule.id)){
                      await localViolationDetailsProvider.removeRule(rule);
                    }else{
                      await localViolationDetailsProvider.pushRule(rule);
                    }
                  },
                  child: TemplateContainerCard(
                    backgroundColor: localViolationDetailsProvider.localViolationCopy.rules
                      .any((element) => element.id == rule.id) ? primaryColor : Colors.black12,
                      textColor: localViolationDetailsProvider.localViolationCopy.rules
                      .any((element) => element.id == rule.id) ? null : Colors.black,
                    title: '${rule.name} (${rule.charge} kr)',
                    // icon: Icons.euro,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
    },
  );
}

}

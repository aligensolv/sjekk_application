import 'dart:async';
import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/utils/router_utils.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
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
import '../providers/violation_details_provider.dart';
import '../widgets/template/components/template_dialog.dart';
import '../widgets/template/components/template_image.dart';
import 'gallery_view.dart';
import 'local_select_rule_screen.dart';
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
                  place: context.read<PlaceProvider>().selectedPlace
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

        
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(localViolationDetailsBack,zIndex: 2,context: context);
        final provider = Provider.of<LocalViolationDetailsProvider>(context,listen: false);

    DateTime parsedCreatedAt = DateTime.parse(provider.localViolationCopy.createdAt);
      int maxTimePolicy = 0;
      if(provider.localViolationCopy.rules.any((element) => element.policyTime > 0)){
        maxTimePolicy = provider.localViolationCopy.rules.map((e){
          print(e.policyTime.toString());
          return e.policyTime;
        }).reduce(max);
      }

      print(maxTimePolicy);
    if(DateTime.now().difference(parsedCreatedAt).inMinutes < maxTimePolicy){
      Provider.of<LocalViolationDetailsProvider>(context, listen: false).updateTimePolicy();
    }
  final localViolationDetailsProvider = Provider.of<LocalViolationDetailsProvider>(context, listen: false);
    
        innerController.text = localViolationDetailsProvider.localViolationCopy.paperComment;
        outterController.text = localViolationDetailsProvider.localViolationCopy.outComment;
  }


  @override
  void dispose() {
    BackButtonInterceptor.remove(localViolationDetailsBack);
    print('i was dispoosed');
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
      ),
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
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TemplateContainerCard(
            title: context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.plate,
            height: 40,
  
            backgroundColor: context.read<LocalViolationDetailsProvider>().localViolationCopy.is_car_registered ? Colors.blue : dangerColor,
          ),
          12.w,
          12.h,
          _buildInfoContainer(
            'TYPE', 
            context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.type, icon: Icons.category,
            editable: true,
            route: SelectCarTypeScreen()
          ),
          _buildInfoContainer('STATUS', context.read<LocalViolationDetailsProvider>().localViolationCopy.status.toUpperCase(), icon: FontAwesome.exclamation),
          _buildInfoContainer('BRAND', context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.brand,icon: FontAwesome.car),
          _buildInfoContainer('YEAR', context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.year, icon: Icons.calendar_month),
          _buildInfoContainer('DESCRIPTION', context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.description, icon: Icons.text_fields),
          _buildInfoContainer('COLOR', context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.color, icon: Icons.color_lens),
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
          return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: localViolationDetailsProvider.localViolationCopy.rules.length,
              separatorBuilder: (context,index){
                return 12.h;
              },
              itemBuilder: ((context, index) {
                Rule rule = localViolationDetailsProvider.localViolationCopy.rules[index];
                return GestureDetector(
                  onTap: (){
          
                  },
                  child: TemplateContainerCard(
                    backgroundColor: primaryColor,
                    title: '${rule.name} (${rule.charge} kr)',
                  ),
                );
              }),
            ),
          ),

          12.h,
          NormalTemplateButton(
            text: 'ADD RULE',
            width: double.infinity,
            backgroundColor: secondaryColor,
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LocalSelectRuleScreen())
              );
            },
          )
        ],
      ),
    );
    },
  );
}

Widget PrintWidget(){

  final media = MediaQuery.of(context).size;

  return Consumer<LocalViolationDetailsProvider>(
    builder: (BuildContext context, LocalViolationDetailsProvider localViolationDetailsProvider, Widget? child) { 
      // DateTime parsedCreatedAt = DateTime.parse(localViolationDetailsProvider.localViolationCopy.createdAt);
              // final provider = Provider.of<ViolationDetailsProvider>(context,listen: false);
        // int maxTimePolicy = 0;
        // if(provider.violation.rules.any((element) => element.timePolicy > 0)){
        //   maxTimePolicy = provider.violation.rules.map((e) => e.timePolicy).reduce(max);
        // }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(localViolationDetailsProvider.isTimerActive)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TemplateParagraphText('You Have wait ${localViolationDetailsProvider.maxTimePolicy} minutes before printing'),
                  12.h,
                  TemplateHeadlineText(
                    'Time passed: ${localViolationDetailsProvider.timePassed}'
                  ),
                ],
              ),
              if(localViolationDetailsProvider.isTimerActive)
              24.h,
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: localViolationDetailsProvider.printOptions.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: (){
                        localViolationDetailsProvider.setSelectedPrintOptionIndex(index);
                      },
                      child: Container(
                                width: media.width * 0.7,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                      color: localViolationDetailsProvider.selectedPrintOptionIndex == index ? Colors.blue : Colors.black26
                                ),
                                child: Text(
                                  localViolationDetailsProvider.printOptions[index].name,
                                  style: TextStyle(
                                    color: localViolationDetailsProvider.selectedPrintOptionIndex == index ? Colors.white : Colors.black
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
                opacity: localViolationDetailsProvider.isTimerActive ? 0.5 : 1,
                child: AbsorbPointer(
                  absorbing: localViolationDetailsProvider.isTimerActive,
                  child: NormalTemplateButton(
                    width: double.infinity,
                    backgroundColor: secondaryColor,
                    onPressed: ()async{

                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                      if(file != null){
                        await localViolationDetailsProvider.pushImage(file.path);
                        SnackbarUtils.showSnackbar(context, 'VL is completed');
                        Navigator.popUntil(context, (route) => route.settings.name == BottomScreenNavigator.route || route.settings.name == PlaceHome.route);
                        await Provider.of<CreateViolationProvider>(context, listen: false).createViolation(
                          violation: localViolationDetailsProvider.localViolationCopy,
                          place: localViolationDetailsProvider.localViolationCopy.place,
                          selectedRules: localViolationDetailsProvider.localViolationCopy.rules.map((e){
                          return e.id!;
                          }).toList()
                        );
                      }
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

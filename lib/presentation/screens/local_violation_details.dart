import 'dart:async';
import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
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
          options: [
            TemplateOption(
              text: 'SAVE', 
              icon: Icons.download, 
              backgroundColor: secondaryColor,
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () async{
                final createViolationProvider = Provider.of<CreateViolationProvider>(context, listen: false);
                await createViolationProvider.setSavedViolation(
                  s_violation: context.read<LocalViolationDetailsProvider>().localViolationCopy
                );
                await createViolationProvider.saveViolation(

                );

                if(createViolationProvider.errorState && createViolationProvider.errorType == CreateViolationProviderErrorType.saving_error){
                  SnackbarUtils.showSnackbar(context, createViolationProvider.errorMessage,type: SnackBarType.failure);
                }else{
                  entry?.remove();
                  SnackbarUtils.showSnackbar(context, 'VL was saved', type: SnackBarType.info);
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == PlaceHome.route
                  );
                }
              }
            ),
            TemplateOption(
              text: 'DELETE', 
              icon: Icons.close, 
              backgroundColor: Colors.red,
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: (){
                entry?.remove();
                Navigator.pop(context);
              }
            ),
            TemplateOption(
              text: 'BACK', 
              icon: Icons.redo,
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

    // if(flag != null && flag != OptionMenuFlags.cancel){
    //   if(flag == OptionMenuFlags.saveViolation){
    //     SnackbarUtils.showSnackbar(context, 'VL was saved', type: SnackBarType.info);
    //     Navigator.of(context).popUntil(
    //       (route) => route.settings.name == PlaceHome.route
    //     );
    //   }else if(flag == OptionMenuFlags.savingError){
    //     final createViolationProvider = Provider.of<CreateViolationProvider>(context, listen: false);
    //     SnackbarUtils.showSnackbar(context, createViolationProvider.errorMessage,type: SnackBarType.failure);
    //   }else if(flag == OptionMenuFlags.deleteViolation){
    //     Navigator.pop(context);
    //   }
    // }

    return true;
  }

        
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(localViolationDetailsBack,zIndex: 2,context: context);
        final provider = Provider.of<LocalViolationDetailsProvider>(context,listen: false);

    DateTime parsedCreatedAt = DateTime.parse(provider.localViolationCopy.createdAt);
      int maxTimePolicy = 0;
      if(provider.localViolationCopy.rules.any((element) => element.timePolicy > 0)){
        maxTimePolicy = provider.localViolationCopy.rules.map((e){
          print(e.timePolicy.toString());
          return e.timePolicy;
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
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   children: [
          //     Expanded(
          //                     child: NormalTemplateButton(
          //                                   onPressed: () async{
          //                                     final createViolationProvider = Provider.of<CreateViolationProvider>(context, listen: false);
          //                                     await createViolationProvider.setSavedViolation(
          //                                       s_violation: context.read<LocalViolationDetailsProvider>().localViolationCopy
          //                                     );
          //                                     await createViolationProvider.saveViolation(

          //                                     );

          //                                     if(createViolationProvider.errorState && createViolationProvider.errorType == CreateViolationProviderErrorType.saving_error){
          //                                       SnackbarUtils.showSnackbar(context, createViolationProvider.errorMessage,type: SnackBarType.failure);
          //                                     }else{
          //                                       SnackbarUtils.showSnackbar(context, 'VL was saved', type: SnackBarType.info);
          //                                       Navigator.popUntil(
          //                                         context, 
          //                                         (route) => route.settings.name == PlaceHome.route
          //                                       );
          //                                     }
          //                                   }, 
          //                                   backgroundColor: secondaryColor,
  
          //                                   text: 'SAVE'
          //                                 ),
          //                   ),
          //                   12.w,
          //     Expanded(
          //                     child: InfoTemplateButton(
          //                                   onPressed: () async{
          //                                     Navigator.pop(context);
          //                                   }, 
          //                                   text: 'CANCEL'
          //                                 ),
          //                   ),
          //   ],
          // ),
          // 12.h,
          TemplateContainerCard(
            title: context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.plate,
            height: 40,
  
            backgroundColor: context.read<LocalViolationDetailsProvider>().localViolationCopy.is_car_registered ? Colors.blue : Colors.red,
          ),
          12.w,
          12.h,
          _buildInfoContainer('Type', context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.type, icon: Icons.category),
          _buildInfoContainer('Status', context.read<LocalViolationDetailsProvider>().localViolationCopy.status.toUpperCase(), icon: FontAwesome.exclamation),
          _buildInfoContainer('Brand', context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.brand,icon: FontAwesome.car),
          _buildInfoContainer('Year', context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.year, icon: Icons.calendar_month),
          _buildInfoContainer('Description', context.read<LocalViolationDetailsProvider>().localViolationCopy.plateInfo.description, icon: Icons.text_fields),
          _buildInfoContainer('Created At', context.read<LocalViolationDetailsProvider>().localViolationCopy.createdAt, icon: Icons.date_range),
    
          if(context.read<LocalViolationDetailsProvider>().localViolationCopy.is_car_registered && context.read<LocalViolationDetailsProvider>().localViolationCopy.registeredCar != null)
          Column(
            children: [
              TemplateHeadlineText('More Information'),
              12.h,
              _buildInfoContainer('Regiseration type', context.read<LocalViolationDetailsProvider>().localViolationCopy.registeredCar!.registerationType),
              _buildInfoContainer('Fra', context.read<LocalViolationDetailsProvider>().localViolationCopy.registeredCar!.startDate),
              _buildInfoContainer('Til', context.read<LocalViolationDetailsProvider>().localViolationCopy.registeredCar!.endDate)
            ],
          )
        ],
      ),
    ),
  );
}

Widget _buildInfoContainer(String title, String value, {IconData? icon = Icons.info_outline}) {
  return Container(
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
                value,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget ImagesWidget(){
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
                        return TemplateFileImageContainer(
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
                  child: TemplateTileContainerCardWithExpandedIcon(
                    height: 40,
                    icon: Icons.euro_symbol,
                    title: '${rule.name} (${rule.charge} \$)',
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
                        await Provider.of<CreateViolationProvider>(context, listen: false).createViolation(
                          violation: localViolationDetailsProvider.localViolationCopy,
                          place: localViolationDetailsProvider.localViolationCopy.place,
                          selectedRules: localViolationDetailsProvider.localViolationCopy.rules.map((e){
                            return e.id;
                          }).toList()
                        );
                        SnackbarUtils.showSnackbar(context, 'VL is completed');
                        Navigator.popUntil(context, (route) => route.settings.name == BottomScreenNavigator.route || route.settings.name == PlaceHome.route);
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

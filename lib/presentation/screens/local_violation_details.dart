import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/home_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/home_screen.dart';
import 'package:sjekk_application/presentation/screens/select_rule_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../data/models/car_image_model.dart';
import '../../data/models/print_option_model.dart';
import '../../data/models/rule_model.dart';
import '../../data/models/violation_model.dart';
import '../providers/create_violation_provider.dart';
import '../providers/local_violation_details_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/template/components/template_dialog.dart';
import '../widgets/template/components/template_image.dart';
import 'gallery_view.dart';
import 'local_select_rule_screen.dart';
import 'place_home.dart';

class LocalViolationDetailsScreen extends StatefulWidget {
  final Violation violation;

  const LocalViolationDetailsScreen({Key? key, required this.violation}) : super(key: key);

  @override
  State<LocalViolationDetailsScreen> createState() => _LocalViolationDetailsScreenState();
}

class _LocalViolationDetailsScreenState extends State<LocalViolationDetailsScreen> {

  @override
  void initState() {
    super.initState();
    DateTime parsedCreatedAt = DateTime.parse(widget.violation.createdAt);
    if(DateTime.now().difference(parsedCreatedAt).inMinutes < 6){
      initializeCounter();
    }
  }

  Timer? _timer;

  void initializeCounter() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
        DateTime parsedCreatedAt = DateTime.parse(widget.violation.createdAt);
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
    return Consumer<LocalViolationDetailsProvider>(
      builder: (BuildContext context, LocalViolationDetailsProvider localViolationDetailsProvider, Widget? child) {  
        TextEditingController innerController = TextEditingController();
        TextEditingController outterController = TextEditingController();

        innerController.text = localViolationDetailsProvider.localViolationCopy.paperComment;
        outterController.text = localViolationDetailsProvider.localViolationCopy.outComment;
        return Padding(
          padding: EdgeInsets.all(12.0),
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
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TemplateContainerCard(
                  title: widget.violation.plateInfo.plate,
                  height: 40,
  
                  backgroundColor: widget.violation.is_car_registered ? Colors.blue : Colors.red,
                ),
              ),
              12.w,
                            Expanded(
                              child: InfoTemplateButton(
                                            onPressed: () async{
                                              Navigator.pop(context);
                                            }, 
                                            text: 'CANCEL'
                                          ),
                            ),
            ],
          ),
          12.h,
                              _buildInfoContainer('Type', widget.violation.plateInfo.type),
          _buildInfoContainer('Status', widget.violation.status),
          _buildInfoContainer('Brand', widget.violation.plateInfo.brand),
          _buildInfoContainer('Year', widget.violation.plateInfo.year),
          _buildInfoContainer('Description', widget.violation.plateInfo.description),
          _buildInfoContainer('Created At', widget.violation.createdAt),
    
          if(widget.violation.is_car_registered && widget.violation.registeredCar != null)
          Column(
            children: [
              TemplateHeadlineText('More Information'),
              12.h,
              _buildInfoContainer('Regiseration type', widget.violation.registeredCar!.registerationType),
              _buildInfoContainer('Fra', widget.violation.registeredCar!.startDate),
              _buildInfoContainer('Til', widget.violation.registeredCar!.endDate)
            ],
          )
        ],
      ),
    ),
  );
}

Widget _buildInfoContainer(String title, String value) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.black12,
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.0),
          alignment: Alignment.center,
          child: Icon(Icons.info_outline,size: 30,color: Colors.white,),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

        Align(
          alignment: Alignment.centerRight,
          child: NormalTemplateButton(
            text: 'ADD',
            onPressed: () async{
              ImagePicker imagePicker = ImagePicker();
              XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
              if(file != null){

                await localViolationDetailsProvider.pushImage(file.path);
              }
            },
          ),
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
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: localViolationDetailsProvider.localViolationCopy.rules.length,
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
          Align(
            alignment: Alignment.centerRight,
            child: NormalTemplateButton(
              text: 'ADD RULE',
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LocalSelectRuleScreen())
                );
              },
            ),
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
      DateTime parsedCreatedAt = DateTime.parse(localViolationDetailsProvider.localViolationCopy.createdAt);
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(DateTime.now().difference(parsedCreatedAt).inMinutes < 6)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TemplateParagraphText('You Have wait 6 minutes before printing'),
                  12.h,
                  TemplateHeadlineText(
                    'Time passed: ${DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().difference(parsedCreatedAt).inMilliseconds))}'
                  ),
                ],
              ),
              if(DateTime.now().difference(parsedCreatedAt).inMinutes < 6)
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
                      color: localViolationDetailsProvider.selectedPrintOptionIndex == index ? Colors.green : Colors.black12
                                ),
                                child: Text(localViolationDetailsProvider.printOptions[index].name),
                              ),
                    );
                  },
                  separatorBuilder: (context,index){
                    return SizedBox(height: 12,);
                  },
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Opacity(
                  opacity: DateTime.now().difference(parsedCreatedAt).inMinutes < 6 ? 0.5 : 1,
                  child: AbsorbPointer(
                    absorbing: false ?? DateTime.now().difference(parsedCreatedAt).inMinutes < 6,
                    child: NormalTemplateButton(onPressed: ()async{
                      await showDialog(
                          context: context,
                          builder: (context){
                            return TemplateSuccessDialog(
                              title: 'Printing VL',
                              message: 'Printing VL And Taking A Picture',
                              
                            );
                          }
                        );

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
              ),
            ],
          ),
        );
    },
  );
}

}

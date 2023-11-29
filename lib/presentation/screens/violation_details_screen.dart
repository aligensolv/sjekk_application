import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
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
import '../widgets/custom_button.dart';
import '../widgets/template/components/template_dialog.dart';
import '../widgets/template/components/template_image.dart';
import 'gallery_view.dart';
import 'place_home.dart';

class ViolationDetailsScreen extends StatefulWidget {
  final Violation violation;

  const ViolationDetailsScreen({Key? key, required this.violation}) : super(key: key);

  @override
  State<ViolationDetailsScreen> createState() => _ViolationDetailsScreenState();
}

class _ViolationDetailsScreenState extends State<ViolationDetailsScreen> {
  @override
  void initState() {
    super.initState();
            DateTime parsedCreatedAt = DateTime.parse(widget.violation.createdAt);
    if(DateTime.now().difference(parsedCreatedAt).inMinutes < 6){
                  initializeCounter();

    }
  }

  void initializeCounter() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
        DateTime parsedCreatedAt = DateTime.parse(widget.violation.createdAt);
    return DefaultTabController(
      initialIndex: 0,
      length: 6,
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
              Tab(
                icon: Icon(Icons.upload_file),
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
                  UploadViolationWidget(),
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
        final TextEditingController innerController = TextEditingController(text: violationDetailsProvider.violation.paperComment);
        final TextEditingController outterController = TextEditingController(text: violationDetailsProvider.violation.outComment);
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
                    await violationDetailsProvider.saveInnerComment(innerController.text);
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
                    await violationDetailsProvider.saveOutterComment(outterController.text);
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

  Widget UploadViolationWidget(){
    return Consumer<ViolationDetailsProvider>(
      builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) { 
        if(violationDetailsProvider.violation.status == 'completed'){
          return Center(
            child: TemplateHeadlineText('Violation is already completed'),
          );
        }
            return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TemplateHeadlineText('Complete VL and upload'),
          12.h,
          TemplateParagraphText("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DangerTemplateButton(
                onPressed: () async{
                  await showDialog(
                    context: context, 
                    builder: (context){
                      return TemplateConfirmationDialog(
                        onConfirmation: () async{
                          await Provider.of<CreateViolationProvider>(context, listen: false).deleteViolation(violationDetailsProvider.violation);
                          Navigator.pop(context);
                          if(Provider.of<CreateViolationProvider>(context, listen: false).errorState){
                            Navigator.pop(context);

                            await showDialog(
                              context: context, 
                              builder: (context){
                                return TemplateFailureDialog(
                                  title: 'Delete Failed', 
                                  message: Provider.of<CreateViolationProvider>(context, listen: false).errorMessage
                                );
                              }
                            );

                          }else{
                            await showDialog(
                              context: context, 
                              builder: (context){
                                return TemplateSuccessDialog(
                                  title: 'Delete Done', 
                                  message: 'VL was successfully deleted',
                                );
                              }
                            );
                          }
                        }, 
                        title: 'Deleting VL', 
                        message: 'Are you sure you want to delete this VL?'
                      );
                    }
                  );
                }, 
                text: 'DELETE'
              ),
              12.w,
              NormalTemplateButton(
                text: 'COMPLETE',
                onPressed: () async{
                  await showDialog(
                    context: context, 
                    builder: (context){
                      return TemplateConfirmationDialog(
                        onConfirmation: () async{
                          await Provider.of<CreateViolationProvider>(context, listen: false).completeViolation(widget.violation);
                          Navigator.pop(context);
                          await showDialog(
                            context: context, 
                            builder: (context){
                              return TemplateSuccessDialog(
                                title: 'Upload Done', 
                                message: 'Violation was successfully uploaded and closed'
                              );
                            }
                          );
                        },  
                        title: 'Complete Violation', 
                        message: 'Are you sure you want to complete this violation?'
                      );
                    }
                  );
                },
              ),
            ],
          )
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
          TemplateContainerCard(
            title: widget.violation.plateInfo.plate,
            backgroundColor: widget.violation.is_car_registered ? Colors.blue : Colors.red,
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
                        return TemplateNetworkImageContainer(
                          path: violationDetailsProvider.violation.carImages[index].path,
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => TemplateGalleryViewScreen(
                                images: violationDetailsProvider.violation.carImages, 
                                initialIndex: index,
                                gallerySource: GallerySource.network,
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
                await violationDetailsProvider.addImage(file.path);
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
  return Consumer<ViolationDetailsProvider>(
    builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) { 
          return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: violationDetailsProvider.violation.rules.length,
              itemBuilder: ((context, index) {
                Rule rule = violationDetailsProvider.violation.rules[index];
                return GestureDetector(
                  onTap: (){
          
                  },
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(bottom: 8.0),
                    alignment: Alignment.center,
                    child: Text('${rule.name} - ${rule.charge}',),
                    decoration: BoxDecoration(
                      color: Colors.black12
                    ),
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
                  MaterialPageRoute(builder: (context) => SelectRuleScreen())
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

  return Consumer<ViolationDetailsProvider>(
    builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) { 
      DateTime parsedCreatedAt = DateTime.parse(violationDetailsProvider.violation.createdAt);
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
                  itemCount: violationDetailsProvider.printOptions.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: (){
                        violationDetailsProvider.setSelectedPrintOptionIndex(index);
                      },
                      child: Container(
                                width: media.width * 0.7,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                      color: violationDetailsProvider.selectedPrintOptionIndex == index ? Colors.green : Colors.black12
                                ),
                                child: Text(violationDetailsProvider.printOptions[index].name),
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
                    absorbing: DateTime.now().difference(parsedCreatedAt).inMinutes < 6,
                    child: NormalTemplateButton(onPressed: ()async{
                      if(violationDetailsProvider.printOptions[violationDetailsProvider.selectedPrintOptionIndex].type == PrintType.hand){
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
                          await violationDetailsProvider.addImage(file.path);
                        }
                      }else{
                        await showDialog(
                          context: context,
                          builder: (context){
                            return TemplateSuccessDialog(
                              title: 'Printing VL',
                              message: 'VL Printing coming soon',
                              
                            );
                          }
                        );
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

/**
 Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.0,),
              if(widget.violation.status == 'saved')
              Align(
                alignment: Alignment.centerRight,
                child: NormalTemplateButton(
                  text: 'Print And Complete',
                  onPressed: (){

                  },
                ),
              ),
              SizedBox(height: 24,),
              if(DateTime.now().difference(parsedCreatedAt).inMinutes < 6)
              TemplateHeadlineText(
                'Time passed: ${DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().difference(parsedCreatedAt).inMilliseconds))}'
              ),
              
              SizedBox(height: 12),
              Text(
                'Place: ${widget.violation.place.location}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
            Text(
              'Policy: ${widget.violation.place.policy}',
              style: TextStyle(fontSize: 16),
            ),
              SizedBox(height: 12),
              Text(
                'Rules:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...widget.violation.rules.map((rule) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('- ${rule.name} -> ${rule.charge}', style: TextStyle(fontSize: 16)),
                  )),
              SizedBox(height: 12),
              Text(
                'Car Images:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              // You can use a widget to display the car images, such as a ListView.builder.
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0
                ),
                itemCount: widget.violation.carImages.length,
                itemBuilder: (context, index) {
                  return Image.network(widget.violation.carImages[index],fit: BoxFit.cover,);
                },
              ),
            ],
          ),
        ),
      )
 */
import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/select_rule_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../data/models/rule_model.dart';
import '../../data/models/violation_model.dart';
import '../providers/create_violation_provider.dart';
import '../widgets/template/components/template_dialog.dart';
import '../widgets/template/components/template_image.dart';
import 'gallery_view.dart';
import 'place_home.dart';

import 'dart:math';
class ViolationDetailsScreen extends StatefulWidget {
  static const String route = 'violation_details_screen';
  final Violation violation;

  const ViolationDetailsScreen({Key? key, required this.violation}) : super(key: key);

  @override
  State<ViolationDetailsScreen> createState() => _ViolationDetailsScreenState();
}

class _ViolationDetailsScreenState extends State<ViolationDetailsScreen> with SingleTickerProviderStateMixin{

  final TextEditingController innerController = TextEditingController();
  final TextEditingController outterController = TextEditingController();

    Future<bool> violationDetailsBack(bool stopDefaultButtonEvent, RouteInfo info) async{
      context.read<ViolationDetailsProvider>().cancelPrintTimer();
      if(info.currentRoute(context)!.settings.name != ViolationDetailsScreen.route){
        return false;
      }

      return true;
    }
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BackButtonInterceptor.add(violationDetailsBack);
      DateTime parsedCreatedAt = DateTime.parse(widget.violation.createdAt);
      final provider = Provider.of<ViolationDetailsProvider>(context,listen: false);
        int maxTimePolicy = 0;
        
        if(provider.violation.rules.any((element) => element.timePolicy > 0)){
          maxTimePolicy = provider.violation.rules.map((e){
            print(e.timePolicy.toString());
            return e.timePolicy;
          }).reduce(max);

                  print(maxTimePolicy);
      if(DateTime.now().difference(parsedCreatedAt).inMinutes < maxTimePolicy){
        Provider.of<ViolationDetailsProvider>(context, listen: false).updateTimePolicy();
      }
        }
    });

  final violationDetailsProvider = Provider.of<ViolationDetailsProvider>(context,listen: false);
            innerController.text = violationDetailsProvider.violation.paperComment;
        outterController.text = violationDetailsProvider.violation.outComment;
  }



  @override
  void dispose() {
    BackButtonInterceptor.remove(violationDetailsBack);
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
                    await violationDetailsProvider.saveInnerComment(innerController.text);
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


Widget CarInfoWidget() {
  OverlayEntry? entry;
    AnimationController controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);


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
                  child: TemplateContainerCard(
                    title: widget.violation.plateInfo.plate,
                    height: 40,
    
                    backgroundColor: widget.violation.is_car_registered ? Colors.blue : Colors.black54,
                  ),
                ),
                12.w,
                Expanded(
                  child: DangerTemplateButton(
                    onPressed: () async{
                      controller.forward();
                      entry = OverlayEntry(
                        builder: (context){
                          return ScaleTransition(
                            scale: animation,
                            child: TemplateConfirmationDialog(
                              onConfirmation: () async{
                                await Provider.of<CreateViolationProvider>(context, listen: false).deleteViolation(widget.violation);
                                Navigator.pop(context);
                                if(Provider.of<CreateViolationProvider>(context, listen: false).errorState){
                                Navigator.pop(context);
                              
                              SnackbarUtils.showSnackbar(
                                context, 
                                Provider.of<CreateViolationProvider>(context, listen: false).errorMessage
                              );  
                                                        }else{
                            
                                Navigator.of(context).popUntil(
                                  (route) => route.settings.name == PlaceHome.route || route.settings.name == BottomScreenNavigator.route
                                );
                                                        }
                              }, 
                              onCancel: (){
                                controller.reverse();
                                entry?.remove();
                              },
                                title: 'Deleting VL', 
                                message: 'Are you sure you want to delete this VL?'
                              ),
                          );
  }
                      );
  
                      Overlay.of(context).insert(
                        entry!
                      );
                    }, 
                    text: 'DELETE'
                  ),
                ),
              ],
            ),
            12.h,
            _buildInfoContainer('Type', widget.violation.plateInfo.type, icon: Icons.category),
            _buildInfoContainer('Status', widget.violation.status.toUpperCase(), icon: FontAwesome.exclamation),
            _buildInfoContainer('Brand', widget.violation.plateInfo.brand,icon: FontAwesome.car),
            _buildInfoContainer('Year', widget.violation.plateInfo.year, icon: Icons.calendar_month),
            _buildInfoContainer('Description', widget.violation.plateInfo.description, icon: Icons.text_fields),
            _buildInfoContainer('Created At', widget.violation.createdAt, icon: Icons.date_range),
      
            if(widget.violation.is_car_registered && widget.violation.registeredCar != null)
            Column(
              children: [
                TemplateHeadlineText('More Information'),
                12.h,
                _buildInfoContainer('Regiseration type', widget.violation.registeredCar!.registerationType, icon: Icons.app_registration),
                _buildInfoContainer('Fra', widget.violation.registeredCar!.startDate,icon: Icons.start),
                _buildInfoContainer('Til', widget.violation.registeredCar!.endDate, icon: Icons.start)
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buildInfoContainer(String title, String value, {IconData? icon = Icons.info_outline}) {
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

        NormalTemplateButton(
          text: 'ADD IMAGE',
          width: double.infinity,
          backgroundColor: secondaryColor,
          onPressed: () async{
            ImagePicker imagePicker = ImagePicker();
            XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
            if(file != null){
              await violationDetailsProvider.addImage(file.path);
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
            backgroundColor: secondaryColor,
            width: double.infinity,
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SelectRuleScreen())
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

  return Consumer<ViolationDetailsProvider>(
    builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) { 
      // DateTime parsedCreatedAt = DateTime.parse(violationDetailsProvider.violation.createdAt);
        final provider = Provider.of<ViolationDetailsProvider>(context,listen: false);
        // int maxTimePolicy = 0;
        // if(provider.violation.rules.any((element) => element.timePolicy > 0)){
        //   maxTimePolicy = provider.violation.rules.map((e) => e.timePolicy).reduce(max);
        // }
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
                opacity: provider.isTimerActive ? 0.5 : 1,
                child: AbsorbPointer(
                  absorbing: provider.isTimerActive,
                  child: NormalTemplateButton(
                    width: double.infinity,
                    backgroundColor: secondaryColor,
                    onPressed: ()async{

                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                      if(file != null){
                        await violationDetailsProvider.addImage(file.path);
                        await Provider.of<ViolationDetailsProvider>(context, listen: false).completeViolation();
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
// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:scanbot_sdk/json/common_platform.dart';
// import 'package:scanbot_sdk/license_plate_scan_data.dart';
// import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
// import 'package:sjekk_application/core/constants/app_images.dart';
// import 'package:sjekk_application/core/helpers/theme_helper.dart';
// import 'package:sjekk_application/core/utils/snackbar_utils.dart';
// import 'package:sjekk_application/data/models/car_image_model.dart';
// import 'package:sjekk_application/data/models/plate_info_model.dart';
// import 'package:sjekk_application/data/models/print_option_model.dart';
// import 'package:sjekk_application/data/models/rule_model.dart';
// import 'package:sjekk_application/data/models/violation_model.dart';
// import 'package:sjekk_application/data/repositories/remote/autosys_repository_impl.dart';
// import 'package:sjekk_application/presentation/providers/create_violation_provider.dart';
// import 'package:sjekk_application/presentation/providers/place_provider.dart';
// import 'package:sjekk_application/presentation/providers/rule_provider.dart';
// import 'package:sjekk_application/presentation/screens/gallery_view.dart';
// import 'package:sjekk_application/presentation/screens/place_home.dart';
// import 'package:sjekk_application/presentation/screens/violation_details_screen.dart';
// import 'package:sjekk_application/presentation/widgets/custom_button.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_dialog.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_image.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
// import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';

// import '../providers/place_provider.dart';
// import '../providers/violation_details_provider.dart';



// class CreateViolationScreen extends StatefulWidget {
//   static const String route = "createViolationScreen";
//   CreateViolationScreen({super.key});

//   @override
//   State<CreateViolationScreen> createState() => _CreateViolationScreenState();
// }

// class _CreateViolationScreenState extends State<CreateViolationScreen> {


//   @override
//   void initState() {
//     super.initState();
//     initializeRules();
//   }

//   void initializeRules() async{
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
//       await Provider.of<RuleProvider>(context, listen: false).fetchRules();
//     });
//   }

//   int _selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Row(
//           children: [
//             Expanded(
//               child: [
//                 CameraScanner(context: context),
//                 RulesWidget(context),
//                 CommentsWidget(context),
//                 CarImagesWidget(context),
//               ][_selectedIndex],
//             ),
//             NavigationRail(
//               groupAlignment: 0,
//               backgroundColor: ThemeHelper.secondaryColor,
              
//               unselectedIconTheme: IconThemeData(
//                 color: Colors.white,
//                 size: 50
//               ),
//               useIndicator: false,
//               selectedIconTheme: IconThemeData(
//                 color: ThemeHelper.primaryColor,
//                 size: 50
//               ),
    
//               onDestinationSelected: (index){
//                 _selectedIndex = index;
//                 setState(() {
    
//                 });
//               },
            
//               destinations: [
//                 NavigationRailDestination(icon: Icon(Icons.camera), label: Text('camera')),
//                 NavigationRailDestination(icon: Icon(Icons.rule), label: Text('rules')),
//                 NavigationRailDestination(icon: Icon(Icons.comment), label: Text('comments')),
//                 NavigationRailDestination(icon: Icon(Icons.image), label: Text('Images')),
//               ], selectedIndex: _selectedIndex)
//           ],
//         ),
//       ),
//     );
//   }

//   Widget CarImagesWidget(BuildContext context){
//     return Consumer<CreateViolationProvider>(
//       builder: (BuildContext context, CreateViolationProvider value, Widget? child) { 
//         return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         children: [
//           if(value.carImages.isEmpty)
//           Text('No Images',style: TextStyle(
//             color: ThemeHelper.textColor,
//             fontSize: 18
//           ),)

//           else
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 8.0,
//                 crossAxisSpacing: 8.0
//               ),
              
//               itemCount: value.carImages.length,
//               itemBuilder: (context,index){
//                 return TemplateFileImageContainer(
//                   path: value.carImages[index].path,
//                   onTap: (){
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => TemplateGalleryViewScreen(
//                         images: value.carImages, 
//                         initialIndex: index,
//                         gallerySource: GallerySource.file,
//                       ))
//                     );
//                   },
//                 );
//               },
              
//             ),
//           ),

//           Spacer(),

//               NormalTemplateButton(
//                 onPressed: () async{
//                   ImagePicker imagePicker = ImagePicker();
//                   XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
//                   if(file != null){
//                     String path = file.path;
//                     CarImage carImage = CarImage(path: path);

//                     Provider.of<CreateViolationProvider>(context, listen: false).addImage(carImage);
//                   }
//                 },
//                 width: double.infinity,
//                 text: 'Take A picture',
//               )
//         ],
//       ),
//     );
//       },
//     );
//   }

//   Widget CommentsWidget(BuildContext context){
//     return Consumer<CreateViolationProvider>(
//       builder: (BuildContext context, CreateViolationProvider value, Widget? child) { 
//         final TextEditingController _paperController = TextEditingController(text: value.paper_comment);
//         final TextEditingController _outController = TextEditingController(text: value.out_comment);
//         return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         children: [
//           NormalTemplateTextField(
//             controller: _paperController,
//             onChanged: (val){
//               value.setPaperComment(val);
//             },
//             lines: 5,
//             hintText: 'Inline comment',
//           ),
//           SizedBox(height: 12,),
//           NormalTemplateTextField(
//             controller: _outController,
//             onChanged: (val){
//               value.setOutComment(val);
//             },
//             hintText: 'Out Comment',
//             lines: 5,
//           ),
//         ],
//       ),
//     );
//       },
//     );
//   }

//   Widget RulesWidget(BuildContext context){
//     return Consumer2<RuleProvider,CreateViolationProvider>(
//       builder: (BuildContext context, RuleProvider value,CreateViolationProvider value2, Widget? child) { 
//         if(value.rules.isEmpty){
//       return Center(
//         child: Text('No Rules Available'),
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: value.rules.length,
//             itemBuilder: ((context, index) {
//               Rule rule = value.rules[index];
//               return GestureDetector(
//                 onTap: (){
//                   if(value.contains(rule.id)){
//                     value.unselect(rule.id);
//                     value2.removeRule(rule);
//                   }else{
//                     value.select(rule.id);
//                     value2.addRule(rule);
//                   }
//                 },
//                 child: Container(
//                   height: 40,
//                   margin: EdgeInsets.only(bottom: 8.0),
//                   alignment: Alignment.center,
//                   child: Text('${rule.name} - ${rule.charge}',style: TextStyle(
//                     color: Colors.white
//                   ),),
//                   decoration: BoxDecoration(
//                     color: value.contains(rule.id) ? Colors.green : ThemeHelper.secondaryColor
//                   ),
//                 ),
//               );
//             }),
//           ),

//           SizedBox(height: 48,),
//           Text('Selected Rules'),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: value2.rules.length,
//             itemBuilder: (context,index){
//               return Text(value2.rules[index].name);
//             },
//           )
//         ],
//       ),
//     );
//       },
//     );
//   }
// }

// class CameraScanner extends StatefulWidget {
//   const CameraScanner({
//     super.key,
//     required this.context,
//   });

//   final BuildContext context;

//   @override
//   State<CameraScanner> createState() => _CameraScannerState();
// }

// class _CameraScannerState extends State<CameraScanner> {

//   @override
//   void initState() {
//     super.initState();
//     openLPR();
//   }

//   void openLPR() async{
//     try{
//       final provider = Provider.of<CreateViolationProvider>(context, listen: false);
//       if(provider.plateInfo == null){
//             var config = LicensePlateScannerConfiguration(
//                     topBarBackgroundColor: ThemeHelper.primaryColor,  
//                     scanStrategy: LicensePlateScanStrategy.ML_BASED,
//                     cameraModule: CameraModule.BACK,
                    
//                     confirmationDialogAccentColor: Colors.green);
//             LicensePlateScanResult result = await ScanbotSdkUi.startLicensePlateScanner(config);
//             await Provider.of<CreateViolationProvider>(context, listen: false).getCarInfo(result.licensePlate); 
//             await Provider.of<CreateViolationProvider>(context, listen: false).getSystemCar(result.licensePlate);
//       }
//     }catch(e){
//       SnackbarUtils.showSnackbar(context, e.toString(), type: SnackBarType.failure);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final media = MediaQuery.of(context).size;

//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Consumer<CreateViolationProvider>(
//       builder: (BuildContext context, CreateViolationProvider value, Widget? child) { 
//         if(value.errorState){
//           return Padding(
//             padding: EdgeInsets.all(12.0),
//             child: TemplateParagraphText(value.errorMessage),
//           );
//         }

//         if(value.plateInfo == null){
//           return Container();
//         }

//         return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//               BasicButton(onPressed: () async{
//                   Violation? savedViolation = await Provider.of<CreateViolationProvider>(context, listen: false).saveViolation(context);
//                   if(savedViolation != null){
//                     await showDialog(
//                       context: context,
//                       builder: (context){
//                         return TemplateSuccessDialog(
//                           title: 'Saving VL', 
//                           message: 'VL was saved'
//                         );
//                       }
//                     );
//                     Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(savedViolation);
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: savedViolation))
//                     );
//                     // Navigator.of(context).popUntil(ModalRoute.withName(PlaceHome.route));
//                   }else{
//                     SnackbarUtils.showSnackbar(context, Provider.of<CreateViolationProvider>(context, listen: false).errorMessage);
//                   }
//                 }, text: 'SAVE'),

//                 12.w,
//                   BasicButton(onPressed: () async{
//                     final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
//                   bool createdViolation = await Provider.of<CreateViolationProvider>(context, listen: false).createViolation(
                    
//                   );
//                   if(createdViolation){
//                     await showDialog(
//                       context: context,
//                       builder: (context){
//                         return TemplateSuccessDialog(
//                           title: 'Creating VL', 
//                           message: 'VL was created'
//                         );
//                       }
//                     );
//                     // Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(savedViolation);
//                     // Navigator.of(context).pushReplacement(
//                     //   MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: savedViolation))
//                     // );
//                     Navigator.of(context).popUntil(ModalRoute.withName(PlaceHome.route));
//                   }else{
//                     SnackbarUtils.showSnackbar(context, Provider.of<CreateViolationProvider>(context, listen: false).errorMessage);
//                   }
//                 },backgroundColor: Colors.green, text: 'CREATE')
//           ],
//         ),
//         SizedBox(height: 12.0,),
//         Text('Car Information',style: TextStyle(
//           color: ThemeHelper.textColor,
//           fontSize: 18
//         ),),
//         SizedBox(height: 12,),
//         Align(
//           alignment: Alignment.centerRight,
//           child: Image.asset(AppImages.cars[value.plateInfo!.brand] ?? AppImages.cars['Unknown'] ?? AppImages.cars),
//         ),
//         SizedBox(height: 12.0,),

//         Container(
//           width: media.width * 0.7,
//           height: 40,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: value.isRegistered ? Colors.blue : dangerColor
//           ),
//           child: Text(value.plateInfo!.plate,style: TextStyle(
//             color: Colors.white
//           ),),
//         ),
//         SizedBox(height: 12,),
//         Container(
//           width: media.width * 0.7,
//           height: 40,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.black12
//           ),
//           child: Text(value.plateInfo!.brand),
//         ),
//         SizedBox(height: 12.0,),
//         Container(
//           width: media.width * 0.7,
//           height: 40,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.black12
//           ),
//           child: Text(value.plateInfo!.year),
//         ),
//         SizedBox(height: 12.0,),
//         Container(
//           width: media.width * 0.7,
//           height: 40,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.black12
//           ),
//           child: Text(value.plateInfo!.description),
//         ),
//         SizedBox(height: 12.0,),
//         Container(
//           width: media.width * 0.7,
//           height: 40,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.black12
//           ),
//           child: Text(value.plateInfo!.type),
//         ),
//         if(value.registeredCar != null)
//         Column(
//           children: [
//             SizedBox(height: 12.0,),
//         Container(
//           width: media.width * 0.7,
//           height: 40,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.black12
//           ),
//           child: Text(value.registeredCar!.registerationType),
//         ),
//         SizedBox(height: 12.0,),
//         Container(
//           width: media.width * 0.7,
//           height: 40,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.black12
//           ),
//           child: Text(value.registeredCar!.startDate),
//         ),
//         SizedBox(height: 12.0,),
//         Container(
//           width: media.width * 0.7,
//           height: 40,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.black12
//           ),
//           child: Text(value.registeredCar!.endDate),
//         ),
//         SizedBox(height: 12.0,),
//         Container(
//           width: media.width * 0.7,
//           height: 40,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.black12
//           ),
//           child: Text(value.registeredCar!.createdAt),
//         ),
//         SizedBox(height: 12.0,),
//           ],
//         )
//       ],
//     );
//       },
//     ),
//     );
//   }
// }


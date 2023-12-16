// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:sjekk_application/core/constants/app_images.dart';
// import 'package:sjekk_application/core/utils/logger.dart';
// import 'package:sjekk_application/data/models/place_model.dart';
// import 'package:sjekk_application/data/models/plate_info_model.dart';
// import 'package:sjekk_application/data/models/registered_car_model.dart';
// import 'package:sjekk_application/presentation/providers/create_violation_provider.dart';
// import 'package:sjekk_application/presentation/providers/place_provider.dart';
// import 'package:sjekk_application/presentation/screens/plate_result_info.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
// import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
// import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

// import '../../core/utils/snackbar_utils.dart';
// import '../../data/models/violation_model.dart';
// import '../providers/local_violation_details_provider.dart';
// import '../providers/violation_details_provider.dart';
// import 'local_violation_details.dart';
// import 'place_home.dart';
// import 'unknown_plate_result_info.dart';
// import 'violation_details_screen.dart';

// class PlateResultController extends StatelessWidget {
//   static const String route = "plate_result_controller";
//   const PlateResultController({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Place? currentPlace = Provider.of<PlaceProvider>(context, listen: false).selectedPlace;

//     return Scaffold(
//       backgroundColor: scaffoldColor,
//       body: Consumer<CreateViolationProvider>(
//         builder: (BuildContext context, CreateViolationProvider createViolationProvider, Widget? child) { 
//           if(createViolationProvider.registeredCar != null 
//             && createViolationProvider.registeredCar!.place?.id == context.read<PlaceProvider>().selectedPlace!.id) {
//             return RegisteredCarWidget(
//               registeredCar: createViolationProvider.registeredCar!,
//               plateInfo: createViolationProvider.plateInfo!,
//               place: currentPlace,
//             );
//           }else{
//             return NotRegisteredCarWidget(
//               plateInfo: createViolationProvider.plateInfo!,
//               place: currentPlace,
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class NotRegisteredCarWidget extends StatelessWidget {
//   const NotRegisteredCarWidget({
//     super.key,
//     required this.plateInfo,
//     required this.place
//   });

//   final PlateInfo plateInfo;
//   final Place? place;

//   @override
//   Widget build(BuildContext context) {
//         DateFormat formatter = DateFormat('HH:mm');

//     return SizedBox(
//       width: double.infinity,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             12.h,
//             if(plateInfo.brand != null)
//             Image.asset(
//               AppImages.cars[plateInfo.brand!.toLowerCase()] ?? AppImages.cars['Unknown'],
//               width: 220,
//               height: 220,
//               fit: BoxFit.contain,
//             )
//             else
//             Image.asset(
//               AppImages.cars['Unknown'],
//               width: 220,
//               height: 220,
//               fit: BoxFit.contain,
//             ),
//             12.h,
//             TemplateContainerCard(  
//               title: plateInfo.plate.isEmpty ? 'N/A' : plateInfo.plate,
//               backgroundColor: dangerColor,
//               fontSize: 24,
//             ),
//             12.h,
//                         if(context.read<CreateViolationProvider>().existingSavedViolation != null)
//             GestureDetector(
//               onTap: (){
//                 Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(
//                     context.read<CreateViolationProvider>().existingSavedViolation!
//                   );

//                   Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: context.read<CreateViolationProvider>().existingSavedViolation!))
//           );
//               },
//               child: Container(
//                 color: Colors.black12,
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     TemplateHeadlineText(
//                       'Saved Violation was found',
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Icon(Icons.saved_search,size: 30,),
//                               Text(
//                               formatter.format(
//                                 DateTime.parse(context.read<CreateViolationProvider>().existingSavedViolation!.createdAt)
//                               ),
//                               style: TextStyle(
//                                 fontSize: 20
//                               ),
//                         ),
//                             ],
//                           ),
//                         ),
//                         Icon(Icons.chevron_right,size: 30,)
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             12.h,
//             TemplateHeadlineText(
//               "${place?.code ?? 'N/A'} - ${place?.location ?? 'N/A'}"
//             ),
//             12.h,
//             Row(
//               children: [
//                 Expanded(
//                   child: NormalTemplateButton(
//                     onPressed: (){
//                       Navigator.of(context).pushNamed(
//                         UnknownPlateResultInfo.route,
//                         arguments: {
//                           'plateInfo': plateInfo,
//                           'place': place,
//                           'registeredCar': null
//                         }
//                       );
//                     },
//                     text: 'INFO',
//                   ),
//                 ),
//                 12.w,
//                 Expanded(
//                   child: InfoTemplateButton(
//                     onPressed: () async{
//                       await Provider.of<CreateViolationProvider>(context,listen: false).setSavedViolation(
//                         place: context.read<PlaceProvider>().selectedPlace
//                       );
//                       Violation? savedViolation = await Provider.of<CreateViolationProvider>(context, listen: false).saveViolation();
//                       if(savedViolation != null){
//                     SnackbarUtils.showSnackbar(context, 'VL was saved', type: SnackBarType.info);
//                     Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(savedViolation);
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: savedViolation)),
//                       (route) => route.settings.name == PlaceHome.route
//                     );
//                     // Navigator.of(context).popUntil(ModalRoute.withName(PlaceHome.route));
//                   }else{
//                     SnackbarUtils.showSnackbar(context, Provider.of<CreateViolationProvider>(context, listen: false).errorMessage);
//                   }
//                     },
//                     text: 'LARGE',
//                   ),
//                 ),
//                 12.w,
//                 Expanded(
//                   child: NormalTemplateButton(
//                     onPressed: () async{
//                       Violation? violation = Violation(
//                         rules: [], 
//                         status: 'LOCAL', 
//                         createdAt: DateTime.now().toLocal().toString(),
//                         plateInfo: plateInfo, 
//                         carImages: [], 
//                         place: place!, 
//                         paperComment: '', 
//                         outComment: '', 
//                         is_car_registered: false,  
//                         registeredCar: null, 
//                         completedAt: null
//                       );
//                       Provider.of<ViolationDetailsProvider>(context,listen: false).setViolation(violation);
//                       Provider.of<LocalViolationDetailsProvider>(context,listen: false).storeLocalViolationCopy(violation);
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                         LocalViolationDetailsScreen.route,
//                         (route) => route.settings.name == PlaceHome.route
//                       );
//                     },
//                     text: 'OPPRETT',
//                     backgroundColor: Colors.green,
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RegisteredCarWidget extends StatelessWidget {
//   const RegisteredCarWidget({
//     super.key,
//     required this.registeredCar,
//     required this.plateInfo,
//     required this.place
//   });

//   final RegisteredCar registeredCar;
//   final PlateInfo plateInfo;
//   final Place? place;

//   @override
//   Widget build(BuildContext context) {
//     DateFormat formatter = DateFormat('HH:mm');
//     return SizedBox(
//       width: double.infinity,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             12.h,
//             if(plateInfo.brand != null)
//             Image.asset(
//               AppImages.cars[plateInfo.brand!.toLowerCase()] ?? AppImages.cars['Unknown'],
//               width: 220,
//               height: 220,
//               fit: BoxFit.contain,
//             )
//             else
//             Image.asset(
//               AppImages.cars['Unknown'],
//               width: 220,
//               height: 220,
//               fit: BoxFit.contain,
//             ),
//             TemplateContainerCard(
//               title: plateInfo.plate.toString(),
//               fontSize: 24,
//             ),
//             12.h,
//             if(context.read<CreateViolationProvider>().existingSavedViolation != null)
//             GestureDetector(
//               onTap: (){
//                 Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(
//                     context.read<CreateViolationProvider>().existingSavedViolation!
//                   );

//                   Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: context.read<CreateViolationProvider>().existingSavedViolation!))
//           );
//               },
//               child: Container(
//                 color: Colors.black12,
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     TemplateHeadlineText(
//                       'Saved Violation was found',
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Icon(Icons.saved_search,size: 30,),
//                               Text(
//                               formatter.format(
//                                 DateTime.parse(context.read<CreateViolationProvider>().existingSavedViolation!.createdAt)
//                               ),
//                               style: TextStyle(
//                                 fontSize: 20
//                               ),
//                         ),
//                             ],
//                           ),
//                         ),
//                         Icon(Icons.chevron_right,size: 30,)
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             12.h,
//             TemplateHeadlineText('Sjekk Parking'),
//             12.h,
//             TemplateParagraphText('Fra: ${registeredCar.startDate}'),
//             12.h,
//             TemplateParagraphText('Fra: ${registeredCar.endDate}'),
//             12.h,
//             TemplateHeadlineText(
//               "${place?.code ?? 'N/A'} - ${place?.location ?? 'N/A'}"
//             ),
//             12.h,
      
//             Row(
//               children: [
//                 Expanded(
//                   child: NormalTemplateButton(
//                     onPressed: (){
//                       Navigator.of(context).pushNamed(
//                         PlateResultInfo.route,
//                         arguments: {
//                           'plateInfo': plateInfo,
//                           'place': place,
//                           'registeredCar': registeredCar,
//                         }
//                       );
//                     },
//                     text: 'INFO',
//                   ),
//                 ),
//                 12.w,
//                 Expanded(
//                   child: InfoTemplateButton(
//                     onPressed: () async{
//                       await Provider.of<CreateViolationProvider>(context,listen: false).setSavedViolation(
//                         place: context.read<PlaceProvider>().selectedPlace
//                       );
//                       Violation? savedViolation = await Provider.of<CreateViolationProvider>(context, listen: false).saveViolation();
//                       if(savedViolation != null){
//                         // await showDialog(
//                         //   context: context,
//                         //   builder: (context){
//                         //     return TemplateSuccessDialog(
//                         //       title: 'Saving VL', 
//                         //       message: 'VL was saved'
//                         //     );
//                         //   }
//                         // );
//                     SnackbarUtils.showSnackbar(context, 'VL was saved', type: SnackBarType.info);
//                     Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(savedViolation);
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: savedViolation)),
//                       (route) => route.settings.name == PlaceHome.route
//                     );
//                     // Navigator.of(context).popUntil(ModalRoute.withName(PlaceHome.route));
//                   }else{
//                     SnackbarUtils.showSnackbar(context, Provider.of<CreateViolationProvider>(context, listen: false).errorMessage);
//                   }
//                     },
//                     text: 'LARGE',
//                   ),
//                 ),
//                 12.w,
//                 Expanded(
//                   child: NormalTemplateButton(
//                     onPressed: () async{
//                       Violation? violation = Violation(
//                         rules: [], 
//                         status: 'LOCAL', 
//                         createdAt: DateTime.now().toLocal().toString(),
//                         plateInfo: plateInfo, 
//                         carImages: [], 
//                         place: place!, 
//                         paperComment: '', 
//                         outComment: '', 
//                         is_car_registered: true, 
//                         registeredCar: registeredCar, 
//                         completedAt: null
//                       );
//                       Provider.of<ViolationDetailsProvider>(context,listen: false).setViolation(violation);
//                       Provider.of<LocalViolationDetailsProvider>(context,listen: false).storeLocalViolationCopy(violation);
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                         LocalViolationDetailsScreen.route,
//                         (route) => route.settings.name == PlaceHome.route
//                       );
//                     },
//                     text: 'OPPRETT',
//                     backgroundColor: Colors.green,
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
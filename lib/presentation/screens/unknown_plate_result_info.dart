// import 'package:flutter/material.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:sjekk_application/core/constants/app_images.dart';
// import 'package:sjekk_application/data/models/plate_info_model.dart';
// import 'package:sjekk_application/presentation/screens/place_home.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
// import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
// import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
// import 'package:sjekk_application/presentation/widgets/template/extensions/string_extension.dart';
// import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
// import '../../data/models/place_model.dart';
// import '../../data/models/violation_model.dart';
// import '../providers/create_violation_provider.dart';
// import '../providers/local_violation_details_provider.dart';
// import '../providers/violation_details_provider.dart';
// import 'local_violation_details.dart';
// import 'violation_details_screen.dart';

// class UnknownPlateResultInfo extends StatelessWidget {
//   static const String route = "unknown_plate_result_info";
//   const UnknownPlateResultInfo({super.key, required this.plateInfo, required this.place});
//   final PlateInfo plateInfo;
//   final Place? place;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: scaffoldColor,
//         body: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             children: [
//               Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       color: Colors.black45,
//                       height: 130,
//                       padding: const EdgeInsets.all(12.0),
//                       child: const Icon(FontAwesome.car, size: 30,color: Colors.white,),
//                     ),
//                     12.w,
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           'Kjoretoyinfo'.toHeadline(),
//                           const Divider(thickness: 2,),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: 
//                                 Column(
//                                   children: [
//                                     (plateInfo.type ?? '').toParagraph(),
//                                     (plateInfo.description ?? '').toParagraph(),
//                                   ],
//                                 ),
//                               ),
//                               12.w,
//                               if(plateInfo.brand != null)
//                               Image.asset(
//                                 AppImages.cars[plateInfo.brand!.toLowerCase()] ?? AppImages.cars['Unknown'],
//                                 width: 80,
//                                 height: 80,
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),

//                 12.h,
//                             Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       color: dangerColor,
//                       height: 130,
//                       padding: const EdgeInsets.all(8.0),
//                       child: const Icon(FontAwesome.close, size: 36,color: Colors.white,),
//                     ),
//                     12.w,
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           'ingen gyldig parkering'.toHeadline(),
//                           const Divider(thickness: 2,),
//                           Wrap(
//                             children: [
//                               TemplateParagraphText('Searched Sjekk and no valid parking was found'),
//                               4.h,
//                               TemplateParagraphText('Sjekk Team'),
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),

//                             if(context.read<CreateViolationProvider>().existingSavedViolation != null)
//               GestureDetector(
//                 onTap: () async{
//                   Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(
//                     context.read<CreateViolationProvider>().existingSavedViolation!
//                   );

//                   Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: context.read<CreateViolationProvider>().existingSavedViolation!))
//           );
//                 },
//                 child: Container(
//                   color: Colors.white,
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         color: primaryColor,
//                         height: 130,
//                         padding: const EdgeInsets.all(8.0),
//                         child: const Icon(Icons.saved_search, size: 36,color: Colors.white,),
//                       ),
//                       12.w,
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             'Saved VL Exists'.toHeadline(),
//                             const Divider(thickness: 2,),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Expanded(
//                                   child: Wrap(
//                                     children: [
//                                       TemplateParagraphText('Searched Sjekk and no valid parking was found'),
//                                       4.h,
//                                       TemplateParagraphText('Sjekk Team'),
//                                     ],
//                                   ),
//                                 ),
              
//                                 Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: Icon(Icons.chevron_right, size: 30, color: Colors.black45,),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),

//               const Spacer(),

//               Row(
//                 children: [
//                   Expanded(
//                     child: InfoTemplateButton(
//                       onPressed: (){

//                       },
//                       text: 'SOK',
//                     ),
//                   ),
//                   12.w,
//                   Expanded(
//                     child: NormalTemplateButton(
//                       onPressed: () async{
//                         Violation? violation = Violation(
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
//                       Navigator.of(context).pushAndRemoveUntil(
//                         MaterialPageRoute(
//                           builder: (context) => LocalViolationDetailsScreen(),
//                           settings: const RouteSettings(name: LocalViolationDetailsScreen.route)
//                         ),
//                         (route) => route.settings.name == PlaceHome.route
//                       );
//                       },
//                       text: 'OPPRETT',
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
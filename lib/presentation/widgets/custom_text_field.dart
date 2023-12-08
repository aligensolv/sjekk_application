// import 'package:flutter/material.dart';
// import 'package:sjekk_application/core/helpers/theme_helper.dart';

// class CustomTextFormField extends StatelessWidget {
//   const CustomTextFormField(
//       {super.key,
//         this.secure,
//         required this.controller,
//         required this.labelAndHint,
//         required this.validator, required this.prefixIcon});

//   final TextEditingController controller;
//   final bool? secure;
//   final String labelAndHint;
//   final IconData prefixIcon;
//   final String? Function(String?)? validator;
//   final primaryColor = Colors.blue;


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//                 offset: Offset(-3,3),
//                 color: Colors.transparent,
//                 blurRadius: 3
//             )
//           ]
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.emailAddress,
//         obscureText: secure ?? false,
//         validator: validator,
//         decoration: InputDecoration(
//           hintText: labelAndHint,
//           isDense: true,
//           prefixIcon: Icon(prefixIcon,color: ThemeHelper.secondaryColor,),
//           labelText: labelAndHint,
//           labelStyle: TextStyle(
//               color: ThemeHelper.textColor
//           ),

//           hintStyle: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//           enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: ThemeHelper.secondaryColor),
//               borderRadius: BorderRadius.circular(8.0)
//           ),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: ThemeHelper.secondaryColor),
//               borderRadius: BorderRadius.circular(8.0)
//           ),
//           border: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.transparent),
//               borderRadius: BorderRadius.circular(8.0)
//           ),
//           disabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.transparent),
//               borderRadius: BorderRadius.circular(8.0)
//           ),
//         ),
//       ),
//     );
//   }
// }

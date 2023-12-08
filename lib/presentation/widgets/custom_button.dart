// import 'package:flutter/material.dart';
// import 'package:sjekk_application/core/helpers/theme_helper.dart';

// class BasicButton extends StatelessWidget {
//   BasicButton({super.key, required this.onPressed, required this.text, this.backgroundColor});
//   final VoidCallback onPressed;
//   final String text;
//   Color? backgroundColor;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor != null ? backgroundColor : ThemeHelper.primaryColor,
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
//         elevation: 0,
//         padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0)
//       ),
//       child: Text(
//         text,
//         style: TextStyle(color: Colors.white, fontSize: 16),
//       ),
//     );
//   }
// }

// class CustomFullWidthButton extends StatelessWidget {
//   const CustomFullWidthButton(
//       {super.key, required this.onPressed, required this.text,required this.color});
//   final VoidCallback onPressed;
//   final String text;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           elevation: 4,
//           minimumSize: Size(double.infinity, 50)),
//       child: Text(
//         text,
//         style: TextStyle(color: Colors.white, fontSize: 18),
//       ),
//     );
//   }
// }

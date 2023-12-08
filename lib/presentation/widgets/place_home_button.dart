// import 'package:flutter/material.dart';
// import 'package:sjekk_application/core/helpers/theme_helper.dart';

// class OptionButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;

//   const OptionButton({super.key, required this.text, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: ThemeHelper.primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(0.0)
//         ),
//         minimumSize: Size(size.width * 0.8,size.width * 0.2)
//       ),
//       child: Text(text,style: TextStyle(
//         color: Colors.white,
//         fontSize: 24
//       ),),
//     );
//   }
// }
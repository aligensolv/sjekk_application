// import 'package:flutter/material.dart';

// class ThemeHelper {
//   // static Color primaryColor = Color(0xFF007cfe);
//   // static Color secondaryColor = Color.fromARGB(255, 44, 62, 121);
//   // static Color accentColor = Color(0xA8792B47);

//   static Color primaryColor = Color(0xFF018afe);
//   static Color secondaryColor = Color(0xFF2b435d);
//   static Color accentColor = Color(0xFF000000);
//   static Color buttonColor = Color(0xFFffa101);
//   static Color? textColor = Colors.grey[700];
//   static Color backgroundColor = Color.fromARGB(255, 214, 206, 206);

//   static ThemeData AppTheme = ThemeData(
//     colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)
//   );
//   static ButtonStyle fullSizePrimaryButtonStyle(BuildContext context) {
//     return ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         minimumSize: const Size(double.infinity, 40),
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(0),
//         ),
//         textStyle: buttonTextStyle(context));
//   }

//   static ButtonStyle fullSizeSecondaryButtonStyle(BuildContext context) {
//     return ElevatedButton.styleFrom(
//         backgroundColor: secondaryColor,
//         minimumSize: const Size(double.infinity, 40),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         textStyle: buttonTextStyle(context));
//   }

//   static ButtonStyle normalPrimaryButtonStyle(BuildContext context) {
//     return ElevatedButton.styleFrom(
//       backgroundColor: primaryColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0)
//       )
//     );
//   }

//   static TextStyle buttonTextStyle(BuildContext context) {
//     return const TextStyle(
//       color: Colors.white,
//       fontSize: 16,
//     );
//   }

//   static TextStyle? headingText(BuildContext context) {
//     return Theme.of(context).textTheme.headlineLarge;
//   }
// }


// // class AppTheme {
// //   static ThemeData lightTheme = ThemeData(
// //     primaryColor: Color(0xFF018afe),
// //     textTheme: TextTheme(
// //         headline6: TextStyle(
// //           color: Colors.white,
// //           fontSize: 20.0,
// //           fontWeight: FontWeight.bold,
// //         ),
// //       ),
// //     backgroundColor: Color(0xFFF5F5F5),
// //     scaffoldBackgroundColor: Color(0xFFF5F5F5),
// //     appBarTheme: AppBarTheme(
// //       color: Color(0xFF018afe),
// //     ),
// //     elevatedButtonTheme: ElevatedButtonThemeData(
// //       style: ElevatedButton.styleFrom(
// //         primary: Color(0xFFffa101),
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(8.0),
// //         ),
// //       ),
// //     ),
// //     textButtonTheme: TextButtonThemeData(
// //       style: TextButton.styleFrom(
// //         primary: Colors.grey[700],
// //       ),
// //     ),
// //     inputDecorationTheme: InputDecorationTheme(
// //       border: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(8.0),
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderSide: BorderSide(
// //           color: Color(0xFF018afe),
// //         ),
// //         borderRadius: BorderRadius.circular(8.0),
// //       ),
// //     ),
    
// //   );
// // }

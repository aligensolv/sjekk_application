import 'package:flutter/material.dart';

import 'colors_theme.dart';

TextStyle snackbarTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

EdgeInsetsGeometry snackbarContentPadding = EdgeInsets.symmetric(
    vertical: 12.0,
    horizontal: 16.0,
  );

BoxDecoration successSnackbarDecoration = BoxDecoration(
    color: successColor,
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 1,
        blurRadius: 2,
        offset: Offset(0, 2),
      ),
    ],
  );

BoxDecoration errorSnackbarDecoration = BoxDecoration(
    color: dangerColor,
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 1,
        blurRadius: 2,
        offset: Offset(0, 2),
      ),
    ],
  );
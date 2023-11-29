import 'package:flutter/material.dart';

import 'colors_theme.dart';

InputDecoration textFieldDecorationTheme = InputDecoration(
  filled: true,
  fillColor: primaryColor.withOpacity(0.1),
  isDense: true,
  isCollapsed: true,
  contentPadding: EdgeInsets.all(12.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: primaryColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: primaryColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: primaryColor),
  ),
);

TextStyle textFieldTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
);


InputDecoration anotherStyleTextFieldDecorationTheme = InputDecoration(
  filled: true,
  fillColor: secondaryColor.withOpacity(0.1),
  isDense: true,
  isCollapsed: true,
  contentPadding: EdgeInsets.all(12.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: secondaryColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: secondaryColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: secondaryColor),
  ),
);

TextStyle anotherStyleTextFieldTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
);
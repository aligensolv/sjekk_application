import 'package:flutter/material.dart';

import '../theme/text_field_theme.dart';


class NormalTemplateTextField extends StatelessWidget {
    final Function(String)? onChanged;
  final TextEditingController? controller;
  final String hintText;
  final int? lines;
  bool? isReadOnly;

  NormalTemplateTextField({super.key,this.lines,this.isReadOnly = false,this.onChanged, this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly ?? false,
      onChanged: onChanged,
      maxLines: lines,
      textAlignVertical: TextAlignVertical.center,
      decoration: textFieldDecorationTheme.copyWith(
        hintText: hintText,
      ),
      style: textFieldTextStyle,
    );
  }
}

class NormalTemplateTextFieldWithIcon extends StatelessWidget {
    final Function(String)? onChanged;
  final TextEditingController? controller;
  final IconData icon;
  final String hintText;
  final int? lines;

  NormalTemplateTextFieldWithIcon({super.key,this.lines,this.onChanged, this.controller,required this.icon, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLines: lines,
      textAlignVertical: TextAlignVertical.center,
      decoration: textFieldDecorationTheme.copyWith(
        hintText: hintText,
        prefixIcon: Icon(icon)
      ),
      style: textFieldTextStyle,
    );
  }
}


class SecondaryTemplateTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String hintText;
  final int? lines;

  SecondaryTemplateTextField({super.key,this.lines,this.onChanged, this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: lines,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChanged,
      decoration: anotherStyleTextFieldDecorationTheme.copyWith(
        hintText: hintText,
      ),
      style: anotherStyleTextFieldTextStyle,
    );
  }
}
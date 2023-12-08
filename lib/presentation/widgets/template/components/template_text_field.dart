import 'package:flutter/material.dart';

import '../theme/text_field_theme.dart';


class NormalTemplateTextField extends StatelessWidget {
    Function(String)? onChanged;
   TextEditingController? controller;
   String? Function(String?)? validator;
  final String hintText;
  final int? lines;
  bool? isReadOnly;

  bool secured;

  NormalTemplateTextField({super.key,this.secured = false,this.validator,this.lines,this.isReadOnly = false,this.onChanged, this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly ?? false,
      obscureText: secured,
      validator: validator,
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
  String? Function(String?)? validator;
  bool secured;

  NormalTemplateTextFieldWithIcon({
    super.key,
    this.lines,
    this.onChanged, 
    this.controller,
    required this.icon, 
    required this.hintText,
    this.secured = false,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: secured,
      maxLines: lines,
      validator: validator,
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

  String? Function(String?)? validator;
  bool secured;
  bool? disabled;

  Icon? prefixIcon;
  Icon? suffixIcon;

  VoidCallback? onSuffixIconTapped;
  VoidCallback? onPrefixIconTapped;

  SecondaryTemplateTextField({
    super.key,
    this.lines,
    this.onChanged, 
    this.controller, 
    required this.hintText,
    this.validator,
    this.secured = false,
    this.disabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onPrefixIconTapped,
    this.onSuffixIconTapped
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: lines,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChanged,
      readOnly: disabled ?? false,
      decoration: anotherStyleTextFieldDecorationTheme.copyWith(
        hintText: hintText,
        isDense: true,
        isCollapsed: true,
        prefixIcon: prefixIcon != null ? GestureDetector(
          onTap: onPrefixIconTapped,
          child: prefixIcon,
        ) : null,

        suffixIcon: suffixIcon != null ? GestureDetector(
          onTap: onSuffixIconTapped,
          child: suffixIcon,
        ) : null
      ),
      style: anotherStyleTextFieldTextStyle,
    );
  }
}




class SecondaryTemplateTextFieldWithIcon extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String hintText;
  final int? lines;
  final IconData icon;

    String? Function(String?)? validator;
  bool secured;
  bool? disabled;

  SecondaryTemplateTextFieldWithIcon({
    super.key,
    this.lines = 1,
    this.onChanged, 
    this.controller, 
    required this.hintText,
    this.validator,
    this.secured = false,
    required this.icon,
    this.disabled = false
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: lines,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChanged,
      readOnly: disabled ?? false,
      decoration: anotherStyleTextFieldDecorationTheme.copyWith(
        hintText: hintText,
        prefixIcon: Icon(icon)
      ),
      style: anotherStyleTextFieldTextStyle,
    );
  }
}

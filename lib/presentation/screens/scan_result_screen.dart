import 'package:flutter/material.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';

class ScanResultScreen extends StatelessWidget {
  final String result;
  const ScanResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(result,style: TextStyle(
          color: ThemeHelper.textColor,
          fontSize: 24
        ),),
      ),
    );
  }
}
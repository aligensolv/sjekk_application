import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum SearchType { web, image, news, shopping }


class TempScreen extends StatelessWidget {
   TempScreen({super.key});
   String valCpy = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center( 
          child:  TextField( 
  keyboardType: TextInputType.number, 
),
      ),
      ),
    );
  }
}
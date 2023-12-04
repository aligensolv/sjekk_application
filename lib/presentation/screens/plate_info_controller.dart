import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/presentation/providers/create_violation_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';

class PlateIntoController extends StatelessWidget {
  const PlateIntoController({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CreateViolationProvider>(
        builder: (BuildContext context, CreateViolationProvider createViolationProvider, Widget? child) { 
          if(createViolationProvider.plateInfo == null) {
            return Center(
              child: TemplateParagraphText('Failed to get plate info'),
            );
          }

          return 
        },
      ),
    );
  }
}
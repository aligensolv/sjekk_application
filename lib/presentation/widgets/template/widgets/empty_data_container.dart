import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';

import '../../../../core/constants/app_images.dart';


class EmptyDataContainer extends StatelessWidget {
  final String text;

  EmptyDataContainer({
    super.key,  
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.noData,
            width: 220,
            height: 220,
            fit: BoxFit.cover,
          ),
          12.h,
          TemplateHeaderText(text)
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../../providers/violation_details_provider.dart';
import '../../../screens/completed_violations_details_screen.dart';
import '../../../screens/violation_details_screen.dart';

class CompletedViolationWidget extends StatelessWidget {
  final Violation violation;
  const CompletedViolationWidget({super.key, required this.violation});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(violation);

        Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => CompletedViolationDetailsScreen(violation: violation)))
        );
      },
      child: Container(
        color: Colors.black12,
                padding: EdgeInsets.all(8.0),

        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                          padding: EdgeInsets.all(20.0),

                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.cars[violation.plateInfo.brand]),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                            padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TemplateParagraphText(
                          '${violation.plateInfo.plate} - ${violation.plateInfo.brand}'
                        ),
                        8.h,
                        TemplateParagraphText(
                          '${violation.plateInfo.type} - ${violation.plateInfo.description} - ${violation.plateInfo.year}'
                        ),
                        12.h,
                        TemplateParagraphText('${violation.place.code} - ${violation.place.location}')
                      ],
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                TemplateParagraphText(violation.plateInfo.brand)
              ],
            ),
            8.h,
            Align(
              alignment: Alignment.centerRight,
              child: TemplateParagraphText(violation.completedAt ?? 'N/A'),
            )
          ],
        ),
      ),
    );
  }
}
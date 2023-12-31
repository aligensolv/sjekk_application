import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../../providers/violation_details_provider.dart';
import '../../../screens/violation_details_screen.dart';

class SavedViolationWidget extends StatelessWidget {
  final Violation violation;
  const SavedViolationWidget({super.key, required this.violation});

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    return GestureDetector(
      onTap: (){
        Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(violation);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ViolationDetailsScreen())
        );
      },
      child: Stack(
        children: [
          Container(
            color: Colors.black12,
                    padding: const EdgeInsets.all(8.0),

            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                              padding: const EdgeInsets.all(20.0),

                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            AppImages.cars[violation.plateInfo.brand?.toLowerCase()] ?? AppImages.cars['Unknown']
                          ),
                          fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                                padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TemplateParagraphText(
                              '${violation.plateInfo.plate}  ${violation.plateInfo.brand ?? ''}'
                            ),
                            8.h,
                            TemplateParagraphText(
                              '${violation.plateInfo.type ?? ''}   ${violation.plateInfo.description  ?? ''}   ${violation.plateInfo.year  ?? ''}'
                            ),
                            
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                8.h,
                Align(
                  alignment: Alignment.centerRight,
                  child: TemplateParagraphText(
                    formatter.format(
                      DateTime.parse(
                        violation.createdAt
                      )
                    )
                  ),
                )
              ],
            ),
          ),


          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0)
                              ),
                              child: Text(
                                violation.place.location
                              ),
                            ),
                          )
        ],
      ),
    );
  }
}
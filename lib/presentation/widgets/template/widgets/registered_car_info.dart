import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../../../data/models/registered_car_model.dart';

class RegisteredCarInfo extends StatelessWidget {
  final RegisteredCar registeredCar;
  const RegisteredCarInfo({super.key, required this.registeredCar});

  String? rankMapperIntoString(String rank){
    switch(rank){
      case 'vip':
        return AppImages.vip;

      case 'owner':
        return AppImages.owner;

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.green,
              padding: EdgeInsets.all(8.0),
              
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: rankMapperIntoString(registeredCar.rank) != null ? Image.asset(
                      rankMapperIntoString(registeredCar.rank)!,
                      width: 60,
                      height: 60,
                    ) : null,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TemplateHeadlineText('Rank  --->  ${registeredCar.rank}'),
                      12.h,
                      TemplateParagraphText('Fra  ${registeredCar.startDate.replaceAll('/', '.').replaceAll(':', '.')}'),
                      TemplateParagraphText('Til  ${registeredCar.endDate.replaceAll('/', '.').replaceAll(':', '.')}'),
                      8.h,
                      TemplateParagraphText('PL  ${registeredCar.boardNumber}'),
                      TemplateParagraphText(registeredCar.registerationType),
                      8.h,
                      TemplateParagraphText('Oslo - 30546'),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(registeredCar.createdAt,style: TextStyle(
                          color: Colors.white
                        ),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: secondaryColor,
            width: 40,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.edit,color: Colors.white,size: 30,),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
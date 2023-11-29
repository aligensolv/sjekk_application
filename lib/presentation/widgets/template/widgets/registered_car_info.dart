import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../../../data/models/registered_car_model.dart';

class RegisteredCarInfo extends StatelessWidget {
  final RegisteredCar registeredCar;
  const RegisteredCarInfo({super.key, required this.registeredCar});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: primaryColor,
              padding: EdgeInsets.all(8.0),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TemplateParagraphText('PL  ${registeredCar.boardNumber}'),
                  TemplateParagraphText(registeredCar.registerationType),
                  TemplateParagraphText('Fra  ${registeredCar.startDate}'),
                  TemplateParagraphText('Til  ${registeredCar.endDate}'),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(registeredCar.createdAt,style: TextStyle(
                      color: Colors.white
                    ),),
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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/models/plate_info_model.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../../../data/models/registered_car_model.dart';
import '../../../../data/models/violation_model.dart';
import '../../../screens/completed_violations_details_screen.dart';
import '../../../screens/violation_details_screen.dart';

class PlaceRegisteredVL extends StatelessWidget {
  final Violation vl;
  const PlaceRegisteredVL({super.key, required this.vl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(vl);
        if(vl.status == "completed"){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CompletedViolationDetailsScreen(violation: vl))
          );
        }else{
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ViolationDetailsScreen(violation: vl))
          );
        }
      },
      child: Container(
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
                    TemplateParagraphText(vl.plateInfo.brand,color: Colors.white,),
                    TemplateParagraphText(vl.plateInfo.type, color: Colors.white),
                    TemplateParagraphText(vl.plateInfo.plate, color: Colors.white),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TemplateParagraphText(vl.status,color: Colors.white,),
                          Text(vl.createdAt,style: TextStyle(
                            color: Colors.white
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: vl.status == 'saved' ? Colors.red : Colors.green,
              width: 40,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        String.fromCharCode(vl.status == 'saved' ?  Icons.close.codePoint : Icons.check.codePoint),
                        style: TextStyle(
                          fontFamily: Icons.check.fontFamily,
                          package: Icons.check.fontPackage,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
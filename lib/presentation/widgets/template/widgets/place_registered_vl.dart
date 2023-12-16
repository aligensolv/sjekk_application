import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import '../../../../data/models/violation_model.dart';
import '../../../screens/completed_violations_details_screen.dart';
import '../../../screens/violation_details_screen.dart';

class PlaceRegisteredVL extends StatelessWidget {
  final Violation vl;
  const PlaceRegisteredVL({super.key, required this.vl});

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('HH:mm .dd.MM.yyyy');
    return GestureDetector(
      onTap: () async{
        Provider.of<ViolationDetailsProvider>(context, listen: false).setViolation(vl);
        if(vl.status == "completed"){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CompletedViolationDetailsScreen(violation: vl))
          );
        }else{
          await context.read<ViolationDetailsProvider>().setViolation(vl);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ViolationDetailsScreen())
          );
        }
      },
      child: SizedBox(
        height: 160,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: primaryColor,
                padding: const EdgeInsets.all(8.0),
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TemplateParagraphText(vl.plateInfo.brand ?? '',color: Colors.white,),
                    TemplateParagraphText(vl.plateInfo.type ?? '', color: Colors.white),
                    TemplateParagraphText(vl.plateInfo.plate, color: Colors.white),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatter.format(
                          DateTime.parse(vl.createdAt)
                        ),style: const TextStyle(
                          color: Colors.white
                        ),),
                        TemplateParagraphText(vl.status,color: Colors.white,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: vl.status == 'saved' ? dangerColor : Colors.green,
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
                          fontSize: 40,
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
import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_icon.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

enum SlotType{
  rule,
  square
}

class TemplateSlotsHolder extends StatelessWidget {
  final int length;
  final SlotType type;

  TemplateSlotsHolder({super.key, required this.length, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index){
        if(type == SlotType.rule){
          return Container(
            margin: EdgeInsets.only(right: 4.0),
            alignment: Alignment.center,
            child: TemplateIcon(Icons.horizontal_rule),
          );
        }

        return Container(
          margin: EdgeInsets.only(right: 8.0),
          alignment: Alignment.center,
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: accentColor
            ),
            borderRadius: BorderRadius.circular(4.0)
          ),
        );
      }),
    );
  }

  TextStyle slotStyle = TextStyle(
    fontSize: 50,
  );
}

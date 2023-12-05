import 'package:flutter/material.dart' show Text, Color;
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';

extension string_extensions on String{
  Text toWidget(){
    return Text(this);
  }

  TemplateParagraphText toParagraph({ Color? color}){
    return TemplateParagraphText(this, color: color);
  }

  TemplateHeadlineText toHeadline(){
    return TemplateHeadlineText(this);
  }

  String concat(String other){
    return this + ' ' + other;
  }
}

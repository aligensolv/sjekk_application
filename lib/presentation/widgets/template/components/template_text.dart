import 'package:flutter/material.dart';

class TemplateHeaderText extends StatelessWidget {
  final String text;
  const TemplateHeaderText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}


class TemplateHeadlineText extends StatelessWidget {
  final String text;
  const TemplateHeadlineText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      fontSize: 20
    ),);
  }
}

class TemplateParagraphText extends StatelessWidget {
  final String text;
  Color? color;
  TemplateParagraphText(this.text,{super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      fontSize: 16,
      color: color
    ));
  }
}
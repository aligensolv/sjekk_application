import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../theme/button_theme.dart';

class NormalTemplateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  Color? backgroundColor;
  double? height;
  double? width;

  NormalTemplateButton({
    super.key,
    this.height, 
    this.width, 
    required this.onPressed, 
    required this.text,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: normalButtonStyle.copyWith(
        minimumSize: MaterialStatePropertyAll(
          Size(width ?? 0, height ?? 40)
        ),
        backgroundColor: MaterialStatePropertyAll(backgroundColor ?? primaryColor)
      ),
      child: Text(text, style: normalButtonTextStyle,),
    );
  }
}

class InfoTemplateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  double? height;
  double? width;

  InfoTemplateButton({super.key,this.height,this.width, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: infoButtonStyle.copyWith(
        minimumSize: MaterialStatePropertyAll(
          Size(width ?? 0, height ?? 40)
        )
      ),
      child: Text(text, style: normalButtonTextStyle)
    );
  }
}

class LightTemplateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const LightTemplateButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: lightButtonStyle,
      child: Text(text, style: lighteButtonTextStyle)
    );
  }
}

class DangerTemplateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const DangerTemplateButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: dangerButtonStyle,
      child: Text(text, style: normalButtonTextStyle)
    );
  }
}

class DangerTemplateIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DangerTemplateIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed, 
      style: IconButton.styleFrom(
        backgroundColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero
        ),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
  elevation: 0,
      ),
      icon: Icon(Icons.close,color: Colors.red,size: 32,),
    );
  }
}

class TemplateOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  TemplateOutlinedButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: outlinedButtonStyle,
      child: Text(text),
    );
  }
}

class TemplateOutlinedDangerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  TemplateOutlinedDangerButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: outlinedDangerButtonStyle,
      child: Text(text),
    );
  }
}

class TemplateTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? textColor;

  TemplateTextButton({Key? key,this.textColor, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: textButtonStyle,
      child: Text(text,style: TextStyle(
        color: textColor
      ),),
    );
  }
}

class TemplateButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final Color? textColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;

  TemplateButtonWithIcon({
    Key? key,
    this.textColor = Colors.white,
    this.backgroundColor = primaryColor,
    this.iconColor = Colors.white,
    this.iconSize = 24,
    required this.icon,
    required this.onPressed, 
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: normalButtonStyle.copyWith(
        backgroundColor: MaterialStatePropertyAll(backgroundColor)
      ),
      icon: Icon(icon,color: iconColor,size: iconSize,),
      label: Text(text,style: TextStyle(
        color: textColor
      ),),
    );
  }
}
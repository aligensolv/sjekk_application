import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/list_tile_theme.dart';

class TemplateListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  final Color? titleColor;
  final Color? leadingColor;
  final Color? backgroundColor;

  final IconData? leading;
  
  const TemplateListTile({
    Key? key, 
    required this.title, 
    this.subtitle, 
    this.icon, 
    this.onTap, 
    this.leading,
    this.leadingColor,
    this.titleColor,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)
      ),
      tileColor: backgroundColor != null ? backgroundColor : Colors.black12,
      contentPadding: contentPadding,
      leading: leading != null ? Icon(leading,size: 30,color: Colors.white,) : null,
      title: Text(
        title,
        style: titleTextStyle.copyWith(
          color: titleColor
        ),
      ),
      subtitle: subtitle != null ? Text(
        subtitle.toString(),
        style: subtitleTextStyle,
      ) : null,
      trailing: Icon(
        icon,
        color: leadingColor,
        size: iconSize,
      ),
    );
  }
}

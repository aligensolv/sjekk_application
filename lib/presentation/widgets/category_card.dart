import 'package:flutter/material.dart';

import '../../core/helpers/theme_helper.dart';

class CategoryCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  Color? backgroundColor;  

  CategoryCard({super.key, required this.onTap, required this.icon, required this.title, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? ThemeHelper.primaryColor,
          borderRadius: BorderRadius.circular(0.0),

        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, // Replace with category-specific icons
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

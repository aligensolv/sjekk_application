import 'package:flutter/material.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

class AboutScreen extends StatelessWidget {
  static const String route = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),
          // You can replace the image with an icon or relevant graphic for the Traffic Violations App
          Image.asset(AppImages.kontroll, height: 180, width: 180),
          SizedBox(height: 30),
          Text(
            'Traffic Violations App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'The Traffic Violations App is your go-to solution for managing traffic violations. Stay informed about the latest traffic rules and regulations. Easily report and track violations, pay fines, and receive important updates from traffic authorities.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.mail_outline),
                onPressed: () {
                  // Handle mail button pressed (e.g., contact support)
                },
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.phone),
                onPressed: () {
                  // Handle phone button pressed (e.g., contact support)
                },
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.web),
                onPressed: () {
                  // Handle website button pressed (e.g., link to official website)
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/screens/place_home.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_button.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../core/helpers/theme_helper.dart';
import '../../data/models/place_model.dart';
import '../widgets/template/components/template_text.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const String route = 'place_details';
  final Place place;

  PlaceDetailsScreen({required this.place});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('HH:mm:ss');
    DateTime date = DateTime.now().toLocal();
    final currentDate = dateFormat.format(date);
    final endDate = dateFormat.format(date.add(Duration(minutes: 10)));
    
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.0,),
              Text('Policy',style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 12,),
              TemplateParagraphText('Fra  ${currentDate}'),
              SizedBox(height: 12,),
              TemplateParagraphText('Til  ${endDate}'),
              Divider(thickness: 3,),
              SizedBox(height: 12,),
              Text(
                place.policy,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: NormalTemplateButton(
                  onPressed: () {
                    Provider.of<PlaceProvider>(context, listen: false).selectedPlace = place;
                    Provider.of<PlaceProvider>(context, listen: false).startTime = DateTime.now().toLocal();
                    if(context.mounted){

                      Navigator.pushNamed(context, PlaceHome.route);

                    }
                  },

                  text: 'Agree',
    
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
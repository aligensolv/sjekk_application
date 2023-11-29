import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/presentation/providers/auth_provider.dart';
import 'package:sjekk_application/presentation/screens/completed_violations_screen.dart';
import 'package:sjekk_application/presentation/screens/done_shift.dart';
import 'package:sjekk_application/presentation/screens/places_screen.dart';
import 'package:sjekk_application/presentation/screens/saved_violations_screen.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/template_workspace.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  static const String route = 'home_route';
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              48.h,
              Text(
                'Welcome ${user.username}',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: ThemeHelper.secondaryColor,
                    ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TemplateWorkspace())
                  );
                },
                child: Image.asset(AppImages.fullKontroll),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  TemplateContainerCardWithIcon(
                      title: 'Places',
                      icon: Icons.place,
                      
                      onTap: () async {
                        Navigator.pushNamed(context,PlacesScreen.route);
                      }),
                  TemplateContainerCardWithIcon(
                      title: 'Saved VL', backgroundColor:ThemeHelper.secondaryColor, icon: Icons.save, onTap: () {
                        Navigator.pushNamed(context, SavedViolationScreen.route);
                      }),
                  TemplateContainerCardWithIcon(
                      title: 'Done VL',backgroundColor: Colors.green, icon: Icons.done_all, onTap: () {
                        Navigator.pushNamed(context, CompletedViolationsScreen.route);
                      }),
                  TemplateContainerCardWithIcon(
                      title: 'Done Shift', backgroundColor: Colors.red, icon: Icons.logout, onTap: () {
                        Navigator.pushNamed(context, DoneShiftScreen.route);
                      }),
                ],
              ),

              // Workspace()
            ],
          ),
        ),
      ),
    );
  }
}

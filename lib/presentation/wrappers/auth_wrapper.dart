import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/presentation/providers/auth_provider.dart';
import 'package:sjekk_application/presentation/screens/home_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/login_screen_navigator.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: authProvider.authenticated ? const HomeNavigatorScreen() : const LoginScreenNavigator(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sjekk_application/core/routing/login_router.dart';
import 'package:sjekk_application/core/utils/router_utils.dart';

class LoginScreenNavigator extends StatefulWidget {
  static const String login = '/';
  const LoginScreenNavigator({super.key});

  @override
  State<LoginScreenNavigator> createState() => _LoginScreenNavigatorState();
}

class _LoginScreenNavigatorState extends State<LoginScreenNavigator> {
  final GlobalKey<NavigatorState> _nestedNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_nestedNavigatorKey.currentState!.canPop()) {
          _nestedNavigatorKey.currentState!.pop();
          return false;
        } else {
          showExitConfirmationDialog(context);
          return false;
        }
      },
      child: Navigator(
        key: _nestedNavigatorKey,
        initialRoute: '/',
        onGenerateRoute: LoginRouter.generatedRoute,
      ),
    );
  }
}

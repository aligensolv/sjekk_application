import 'package:flutter/material.dart';
import 'package:sjekk_application/core/utils/router_utils.dart';
import '../../core/routing/home_router.dart';

class HomeNavigatorScreen extends StatefulWidget {
  static const String route = '/home_navigator';

  const HomeNavigatorScreen({super.key});

  @override
  State<HomeNavigatorScreen> createState() => _HomeNavigatorScreenState();
}

class _HomeNavigatorScreenState extends State<HomeNavigatorScreen> {
  final GlobalKey<NavigatorState> _nestedNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_nestedNavigatorKey.currentState!.canPop()) {
          _nestedNavigatorKey.currentState!.pop();
          return false;
        } else {
          // Show the exit confirmation dialog
          showExitConfirmationDialog(context);
          return false;
        }
      },
      child: Scaffold(
        body: Navigator(
          key: _nestedNavigatorKey,
          onGenerateRoute: HomeRouter.generatedRoute,
        ),
      ),
    );
  }
}

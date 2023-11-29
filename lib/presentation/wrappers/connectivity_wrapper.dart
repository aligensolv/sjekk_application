import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/presentation/providers/connectivity_provider.dart';
import 'package:sjekk_application/presentation/screens/no_network_screen.dart';

import 'auth_wrapper.dart';

class ConnectivityWrapper extends StatelessWidget {
  const ConnectivityWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);

    return connectivityProvider.connection ? const AuthWrapper() : const NoInternetScreen();
  }
}

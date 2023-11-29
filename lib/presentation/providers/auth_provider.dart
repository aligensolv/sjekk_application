import 'package:flutter/material.dart';
import 'package:sjekk_application/data/models/user_model.dart';
import 'package:sjekk_application/presentation/providers/shift_provider.dart';

import '../../data/repositories/local/cache_repository_impl.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  bool authenticated = false;
  late User user;

  static AuthProvider? _instance;

  // Private constructor to prevent external instantiation
  AuthProvider._();

  // Singleton instance getter
  static AuthProvider get instance {
    _instance ??= AuthProvider._();
    return _instance!;
  }

  detectAuthenticationState() async {
    String? cachedToken = await CacheRepositoryImpl.instance.get('token');
    if (cachedToken != null) {
      token = cachedToken;
      authenticated = true;

      String? username = await CacheRepositoryImpl.instance.get('username');
      String? identifier = await CacheRepositoryImpl.instance.get('identifier');

      user = User(identifier: identifier, username: username);

      notifyListeners();
    }
  }

  provideAuthenticationState(String newToken, User newUser) async {
    token = newToken;
    authenticated = true;
    user = newUser;

    await CacheRepositoryImpl.instance.set('token', newToken);
    await CacheRepositoryImpl.instance.set('username', newUser.username);
    await CacheRepositoryImpl.instance.set('identifier', newUser.identifier);

    notifyListeners();
  }

  clearAuthenticationState() async {
    token = null;
    authenticated = false;

    await CacheRepositoryImpl.instance.remove('token');
    await CacheRepositoryImpl.instance.remove('username');
    await CacheRepositoryImpl.instance.remove('identifier');

    await ShiftProvider.instance.endShift();

    notifyListeners();
  }
}

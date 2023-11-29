import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier{
  bool _isConnected = false;
  late StreamSubscription subscription;

    static ConnectivityProvider? _instance;

    // Private constructor to prevent external instantiation
    ConnectivityProvider._();

    // Singleton instance getter
    static ConnectivityProvider get instance {
      _instance ??= ConnectivityProvider._();
      return _instance!;
    }

    bool get connection{
      return _isConnected;
    }

    Future init() async {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        _isConnected = true;
      }else{
        _isConnected = false;
      }

      notifyListeners();

      subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
          _isConnected = true;
        }else{
          _isConnected = false;
        }

        notifyListeners();
      });
    }


    @override
    void dispose() {
      subscription.cancel();
      super.dispose();
    }
}
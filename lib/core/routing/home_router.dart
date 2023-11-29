import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/screens/about_screen.dart';
import 'package:sjekk_application/presentation/screens/cars_screen.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/create_violation_screen.dart';
import 'package:sjekk_application/presentation/screens/done_shift.dart';
import 'package:sjekk_application/presentation/screens/home_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/home_screen.dart';
import 'package:sjekk_application/presentation/screens/place_details.dart';
import 'package:sjekk_application/presentation/screens/place_home.dart';
import 'package:sjekk_application/presentation/screens/place_violations.dart';
import 'package:sjekk_application/presentation/screens/places_screen.dart';
import 'package:sjekk_application/presentation/screens/saved_violations_screen.dart';

import '../../presentation/screens/completed_violations_screen.dart';

import '../../presentation/screens/terms_and_conditions.dart';
import '../../presentation/screens/unknown_route_screen.dart';

class HomeRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case BottomScreenNavigator.route:
        return MaterialPageRoute(
          builder: (context) => BottomScreenNavigator(),
          settings: RouteSettings(name: BottomScreenNavigator.route)
        );

      case HomeNavigatorScreen.route:
        return MaterialPageRoute(
          builder: (context) => const HomeNavigatorScreen(),
          settings: RouteSettings(name: HomeNavigatorScreen.route)
        );

      case HomeScreen.route:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
          settings: RouteSettings(name: HomeScreen.route)
        );

      case DoneShiftScreen.route:
        return MaterialPageRoute(builder: (context) => DoneShiftScreen());

      case PlacesScreen.route:
        return MaterialPageRoute(builder: (context) => PlacesScreen());

      case PlaceDetailsScreen.route:
        return MaterialPageRoute(builder: (context) => PlaceDetailsScreen(place: (settings.arguments as Map)['place'],));

      case PlaceHome.route:
        return MaterialPageRoute(
          builder: (context) => PlaceHome(place: (settings.arguments as Map)['place'],),
          settings: RouteSettings(name: PlaceHome.route)
        );

      case CreateViolationScreen.route:
        return MaterialPageRoute(builder: (context) => CreateViolationScreen());

      case BoardsScreen.route:
        return MaterialPageRoute(builder: (context) => BoardsScreen());

      case SavedViolationScreen.route:
        return MaterialPageRoute(builder: (context) => SavedViolationScreen());

      case CompletedViolationsScreen.route:
        return MaterialPageRoute(builder: (context) => CompletedViolationsScreen());

      case PlaceViolations.route:
        return MaterialPageRoute(builder: (context) => PlaceViolations(placeId: (settings.arguments as Map)['id'],));

      case AboutScreen.route:
        return MaterialPageRoute(builder: (context) => AboutScreen());

      case TermsAndConditionsScreen.route:
        return MaterialPageRoute(
            builder: (context) => TermsAndConditionsScreen());
      default:
        return MaterialPageRoute(builder: (context) => UnknownRouteScreen());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:sjekk_application/core/utils/router_utils.dart';
import 'package:sjekk_application/presentation/screens/about_screen.dart';
import 'package:sjekk_application/presentation/screens/add_printer_test.dart';
import 'package:sjekk_application/presentation/screens/cars_screen.dart';
import 'package:sjekk_application/presentation/screens/bottom_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/choose_plate_input.dart';
import 'package:sjekk_application/presentation/screens/completed_violation_brief_information.dart';
import 'package:sjekk_application/presentation/screens/completed_violation_images.dart';
import 'package:sjekk_application/presentation/screens/done_shift.dart';
import 'package:sjekk_application/presentation/screens/home_navigator_screen.dart';
import 'package:sjekk_application/presentation/screens/home_screen.dart';
import 'package:sjekk_application/presentation/screens/local_violation_details.dart';
import 'package:sjekk_application/presentation/screens/place_details.dart';
import 'package:sjekk_application/presentation/screens/place_home.dart';
import 'package:sjekk_application/presentation/screens/place_violations.dart';
import 'package:sjekk_application/presentation/screens/places_screen.dart';
import 'package:sjekk_application/presentation/screens/plate_result_controller.dart';
import 'package:sjekk_application/presentation/screens/plate_result_info.dart';
import 'package:sjekk_application/presentation/screens/printers_settings.dart';
import 'package:sjekk_application/presentation/screens/qrcode_scanner.dart';
import 'package:sjekk_application/presentation/screens/saved_violations_screen.dart';
import 'package:sjekk_application/presentation/screens/select_brand_screen.dart';
import 'package:sjekk_application/presentation/screens/select_car_type_screen.dart';
import 'package:sjekk_application/presentation/screens/select_color_screen.dart';
import 'package:sjekk_application/presentation/screens/unknown_plate_result_info.dart';
import 'package:sjekk_application/presentation/widgets/template/template_workspace.dart';

import '../../presentation/screens/completed_violations_screen.dart';

import '../../presentation/screens/plate_keyboard_input.dart';
import '../../presentation/screens/terms_and_conditions.dart';
import '../../presentation/screens/unknown_route_screen.dart';

class HomeRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case BottomScreenNavigator.route:
        return buildCustomBuilder(BottomScreenNavigator(), settings);

      case PrintersSettings.route:
        return buildCustomBuilder(PrintersSettings(), settings);

      case HomeNavigatorScreen.route:
        return buildCustomBuilder(HomeNavigatorScreen(), settings);

      case HomeScreen.route:
        return buildCustomBuilder(HomeScreen(), settings);

      case DoneShiftScreen.route:
        return buildCustomBuilder(DoneShiftScreen(), settings);

      case PlacesScreen.route:
        return buildCustomBuilder(PlacesScreen(), settings);

      case PlaceDetailsScreen.route:
        return buildCustomBuilder(PlaceDetailsScreen(), settings);

      case PlaceHome.route:
        return buildCustomBuilder(PlaceHome(), settings);

      case BoardsScreen.route:
        return buildCustomBuilder(BoardsScreen(), settings);

      case SavedViolationScreen.route:
        return buildCustomBuilder(SavedViolationScreen(), settings);

      case CompletedViolationsScreen.route:
        return buildCustomBuilder(CompletedViolationsScreen(), settings);

      case PlaceViolations.route:
        return buildCustomBuilder(PlaceViolations(
          placeId: (settings.arguments as Map)['id'],
        ), settings);

      case TemplateWorkspace.route:
        return buildCustomBuilder(TemplateWorkspace(), settings);

      case ChoosePlateInputScreen.route:
        return buildCustomBuilder(ChoosePlateInputScreen(), settings);

      case PlateKeyboardInputScreen.router:
        return buildCustomBuilder(PlateKeyboardInputScreen(), settings);

      case PlateResultInfo.route:
        return buildCustomBuilder(PlateResultInfo(), settings);

      case CompletedViolationBriefInformation.route:
        return buildCustomBuilder(CompletedViolationBriefInformation(
          violation: (settings.arguments as Map)['violation'],
        ), settings);

      case CompletedViolationImages.route:
        return buildCustomBuilder(CompletedViolationImages(), settings);

      case SelectCarBrandScreen.route:
        return buildCustomBuilder(SelectCarBrandScreen(), settings);

      case SelectCarColorScreen.route:
        return buildCustomBuilder(SelectCarColorScreen(), settings);

      case SelectCarTypeScreen.route:
        return buildCustomBuilder(SelectCarTypeScreen(), settings);

      case QrCodeScanner.router:
        return buildCustomBuilder(QrCodeScanner(), settings);

      case LocalViolationDetailsScreen.route:
        return buildCustomBuilder(LocalViolationDetailsScreen(), settings);

      case AboutScreen.route:
        return buildCustomBuilder(AboutScreen(), settings);

      case AddPrinterTest.route:
        return buildCustomBuilder(AddPrinterTest(), settings);

      case TermsAndConditionsScreen.route:
        return buildCustomBuilder(TermsAndConditionsScreen(), settings);
      default:
        return buildCustomBuilder(UnknownRouteScreen(), settings);
    }
  }
}

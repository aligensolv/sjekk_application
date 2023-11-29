import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/presentation/providers/car_provider.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/registered_car_info.dart';

class BoardsScreen extends StatefulWidget {
  static const String route = 'boards_screen';

  @override
  State<BoardsScreen> createState() => _BoardsScreenState();
}

class _BoardsScreenState extends State<BoardsScreen> {
  @override
  void initState() {
    super.initState();
    initializeBoards();
  }

  void initializeBoards() async {
    Place place = Provider.of<PlaceProvider>(context, listen: false).selectedPlace!;
    await Provider.of<CarProvider>(context, listen: false).fetchCarsByPlace(place);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,

      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Consumer<CarProvider>(
          builder: (BuildContext context, CarProvider value, Widget? child) {
            if (value.loadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (value.errorState) {
              return Center(
                child: Text(
                  value.errorMessage,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              );
            }

            if (value.cars.isEmpty) {
              return Center(
                child: Text(
                  'No cars available',
                  style: TextStyle(
                    color: ThemeHelper.textColor,
                    fontSize: 24,
                  ),
                ),
              );
            }

            List<RegisteredCar> cars = value.cars;

            return Container(
              margin: EdgeInsets.only(top: 24),
              child: ListView.separated(
                separatorBuilder: (context,index){
                  return 12.h;
                },
                itemCount: cars.length,
                itemBuilder: ((context, index) {
                  RegisteredCar car = cars[index];
            
                  return RegisteredCarInfo(registeredCar: car);
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

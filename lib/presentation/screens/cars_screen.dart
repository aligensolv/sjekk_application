import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/models/place_model.dart';
import 'package:sjekk_application/data/models/registered_car_model.dart';
import 'package:sjekk_application/presentation/providers/car_provider.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/registered_car_info.dart';

import '../widgets/template/components/template_text_field.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      Place place = Provider.of<PlaceProvider>(context, listen: false).selectedPlace!;
      await Provider.of<CarProvider>(context, listen: false).fetchCarsByPlace(place);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
    
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              NormalTemplateTextFieldWithIcon(
                    onChanged: (val){
                      Provider.of<CarProvider>(context,listen: false).searchCars(val);
                    }, 
                    icon: Icons.search,
                    hintText: 'SEARCH'
                  ),
                  12.h,
              Expanded(
                child: Consumer<CarProvider>(
                  builder: (BuildContext context, CarProvider value, Widget? child) {
                    // if (value.loadingState) {
                    //   return const Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // }
                  
                    if (value.errorState) {
                      return Center(
                        child: TemplateHeaderText(
                          value.errorMessage,
                        ),
                      );
                    }
                  
                    if (value.cars.isEmpty) {
                      return Center(
                        child: TemplateHeadlineText(
                          'No cars available'
                        ),
                      );
                    }
                  
                    List<RegisteredCar> cars = value.cars;
                  
                    return Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}

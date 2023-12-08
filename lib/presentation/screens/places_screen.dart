import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/helpers/theme_helper.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:sjekk_application/presentation/providers/place_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../data/models/place_model.dart';
import 'place_details.dart';

class PlacesScreen extends StatefulWidget {
  static const String route = 'places_screen';
  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  void initState() {
    super.initState();
    initializePlaces();
  }


  void initializePlaces() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
      await placeProvider.fetchPlaces();

    if (placeProvider.errorState) {
      if(mounted){
        SnackbarUtils.showSnackbar(context, placeProvider.errorMessage,
          type: SnackBarType.failure);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Consumer<PlaceProvider>(
          builder: (BuildContext context, PlaceProvider value, Widget? child) {
            // if(value.loadingState){
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
      
            if(value.errorState){
              return Center(
                child: Text(value.errorMessage),
              );
            }
      
            List<Place> places = value.places;
      
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  NormalTemplateTextFieldWithIcon(
                    onChanged: (val){
                      value.searchPlaces(val);
                    }, 
                    icon: Icons.search,
                    hintText: 'Search'
                  ),
                  12.h,
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    separatorBuilder: ((context, index) {
                      return 6.h;
                    }),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      Place place = places[index];
                
                      return TemplateContainerCard(
                        title: '${place.code} \n${place.location}',
                        alignment: Alignment.centerLeft,
                        onTap: (){
                          value.setSelectedPlace(place);
                          value.setSelectedPlaceLoginTime();
                          Navigator.pushNamed(context, PlaceDetailsScreen.route,arguments: {
                            'place': place
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

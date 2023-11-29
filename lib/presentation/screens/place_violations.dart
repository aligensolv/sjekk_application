import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/models/violation_model.dart';
import 'package:sjekk_application/presentation/providers/violations_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/place_registered_vl.dart';

class PlaceViolations extends StatefulWidget {
  static const String route = "place_violations";
  final String placeId;

  const PlaceViolations({Key? key, required this.placeId}) : super(key: key);

  @override
  State<PlaceViolations> createState() => _PlaceViolationsState();
}

class _PlaceViolationsState extends State<PlaceViolations> {
  @override
  void initState() {
    super.initState();
    initializePlaceViolations();
  }

  void initializePlaceViolations() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final violationProvider =
          Provider.of<ViolationProvider>(context, listen: false);
      await violationProvider.fetchPlaceViolations(widget.placeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Consumer<ViolationProvider>(
          builder: (BuildContext context, ViolationProvider value,
              Widget? child) {
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
                    fontSize: 24,
                    color: Colors.red,
                  ),
                ),
              );
            }

            if (value.currentPlaceViolations.isEmpty) {
              return Center(
                child: Text(
                  'No Violations Yet',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            List<Violation> violations = value.currentPlaceViolations;
            return Container(
              margin: EdgeInsets.only(top: 24),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(height: 12,);
                },
                itemCount: violations.length,
                itemBuilder: (context, index) {
                  Violation violation = violations[index];
            
                  return PlaceRegisteredVL(vl: violation);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

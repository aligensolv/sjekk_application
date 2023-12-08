import 'package:auto_size_text/auto_size_text.dart';
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
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: scaffoldColor,
          body: Consumer<ViolationProvider>(
            builder: (BuildContext context, ViolationProvider value,
                Widget? child) {
              if (value.loadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
          
              if (value.errorState) {
                return Center(
                  child: AutoSizeText(
                    value.errorMessage,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                    ),
                    maxLines: 1,
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
              return Column(
                children: [
                  TabBar(
                    tabs: [
                    Tab(
                  text: 'Saved',
                ),
                    Tab(
                  text: 'Completed',
                ),
                    ],
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TabBarView(
                        children: [
                          _buildViolations(violations.where((element) => element.status == 'saved').toList()),
                          _buildViolations(violations.where((element) => element.status == 'completed').toList()),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildViolations(List<Violation> violations){
    return Container(
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
  }
}

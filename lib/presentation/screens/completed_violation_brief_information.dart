import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import '../../data/models/violation_model.dart';

class CompletedViolationBriefInformation extends StatefulWidget {
  static const String route = "completed_violations_summary";
  final Violation violation;

  const CompletedViolationBriefInformation({Key? key, required this.violation}) : super(key: key);

  @override
  State<CompletedViolationBriefInformation> createState() => _CompletedViolationBriefInformationState();
}

class _CompletedViolationBriefInformationState extends State<CompletedViolationBriefInformation> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            24.h,
            const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.info_outline),
              ),
              Tab(
                icon: Icon(Icons.print),
              ),
            ],
          ),
          12.h,
            Expanded(
              child: TabBarView(
                children: [
                  CarInfoWidget(),
                  PrintWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


Widget CarInfoWidget() {
  DateFormat formatter = DateFormat('HH:mm .dd.MM.yyyy');
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TemplateContainerCard(
            title: widget.violation.plateInfo.plate,
            backgroundColor: widget.violation.is_car_registered ? Colors.blue : dangerColor,
          ),
          12.h,
            _buildInfoContainer('TYPE', widget.violation.plateInfo.type, icon: Icons.category),
            _buildInfoContainer('STATUS', widget.violation.status.toUpperCase(), icon: FontAwesome.exclamation),
            _buildInfoContainer('BRAND', widget.violation.plateInfo.brand,icon: FontAwesome.car),
            _buildInfoContainer('YEAR', widget.violation.plateInfo.year, icon: Icons.calendar_month),
            _buildInfoContainer('DESCRIPTION', widget.violation.plateInfo.description, icon: Icons.text_fields),
            _buildInfoContainer('COLOR', widget.violation.plateInfo.color, icon: Icons.color_lens),
            _buildInfoContainer('CREATED AT', formatter.format(DateTime.parse(widget.violation.createdAt)), icon: Icons.date_range),
    
          if(widget.violation.is_car_registered && widget.violation.registeredCar != null)
          Column(
            children: [
              TemplateHeadlineText('MORE INFORMATION'),
              12.h,
                _buildInfoContainer('RANK', widget.violation.registeredCar!.rank.toString().toUpperCase(), icon: Icons.star),
                _buildInfoContainer('REGISTERATION TYPE', widget.violation.registeredCar!.registerationType, icon: Icons.app_registration),
                _buildInfoContainer('FRA', widget.violation.registeredCar!.startDate,icon: Icons.start),
                _buildInfoContainer('TIL', widget.violation.registeredCar!.endDate, icon: Icons.start)
            ],
          )
        ],
      ),
    ),
  );
}

Widget _buildInfoContainer(String title, String? value, {IconData? icon = Icons.info_outline}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: const BoxDecoration(
      color: Colors.black12,
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          alignment: Alignment.center,
          child: Icon(icon,size: 30,color: Colors.white,),
          color: primaryColor,
          height:60,
          width: 60,
        ),
        12.w,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                value ?? '',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}




Widget PrintWidget(){
  return Padding(
    padding: EdgeInsets.all(12.0),
    child: Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.violation.printPaper != null ? 
                CachedNetworkImageProvider(widget.violation.printPaper!) as ImageProvider: const AssetImage(AppImages.gensolv)
              )
            ),
          ),
        )
      ],
    ),
  );
}

}

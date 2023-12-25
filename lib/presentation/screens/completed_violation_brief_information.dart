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
import 'package:sjekk_application/presentation/widgets/template/widgets/empty_data_container.dart';
import '../../data/models/violation_model.dart';
import '../widgets/template/components/template_image.dart';
import 'gallery_view.dart';

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
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            24.h,
            const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(FontAwesome.edit),
              ),
              Tab(
                icon: Icon(Icons.print),
              ),
              Tab(
                icon: Icon(Icons.camera),
              ),
            ],
          ),
            Expanded(
              child: TabBarView(
                children: [
                  CarInfoWidget(),
                  PrintWidget(),
                  ImagesWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


Widget ImagesWidget(){
    DateFormat format = DateFormat('HH:mm');

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
  children: [
    Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0
                  ),
                  
                    itemCount: widget.violation.carImages.length,
                  itemBuilder: (context,index){
                    return Stack(
                      children: [
                        TemplateNetworkImageContainer(
                          path: widget.violation.carImages[index].path,
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => TemplateGalleryViewScreen(
                                images: widget.violation.carImages, 
                                initialIndex: index,
                                gallerySource: GallerySource.network,
                              ))
                            );
                          },
                        ),

                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              color: Colors.black54,
                              child: Text(
                                format.format(
                                  DateTime.parse(widget.violation.carImages[index].date)
                                ),
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            ),
                          )
                      ],
                    );
                  },
                  
                ),
    ),
  ],
    ),
  );
}

Widget CarInfoWidget() {
  return Padding(
    padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
    child: ListView(
      children: [
        ViolationMainData(),
        12.h,
        ViolationRegisteredRules(),
        12.h,
        CarPlateInfo(),
        12.h,
        ViolationPlaceInfo()
      ],
    ),
  );
}

Widget TitleText(String text){
  return TemplateHeadlineText(text,size: 18,color: primaryColor);
}

Widget InfoBlock({
  required String titleText,
  required String blockValue
}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
                    TitleText(titleText),
              2.h,
              TemplateParagraphText(blockValue),
              8.h
    ],
  );
}

Widget ViolationPlaceInfo(){
  return Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.black12
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TemplateHeadlineText('Stedsinfo'),
        12.h,
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              InfoBlock(
                titleText: 'Anlegg', 
                blockValue: 'Olaf Helsetsvie 5'
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget CarPlateInfo(){
  return Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.black12
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TemplateHeadlineText('Kjoretoy Info'),
        12.h,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InfoBlock(
                      titleText: 'Reg.nr', 
                      blockValue: widget.violation.plateInfo.plate
                    ),
                  ),
                  Expanded(
                    child: InfoBlock(
                      titleText: 'Land', 
                      blockValue: 'Norge'
                    ),
                  ),
                ],
              ),
              12.h,
              Row(
                children: [
                  Expanded(
                    child: InfoBlock(
                      titleText: 'Merke', 
                      blockValue: widget.violation.plateInfo.brand ?? 'N/A'
                    ),
                  ),
                  Expanded(
                    child: InfoBlock(
                      titleText: 'Farge', 
                      blockValue: 'Sfart'
                    ),
                  ),
                ],
        
              ),
              12.h,
              InfoBlock(
                titleText: 'Type', 
                blockValue: widget.violation.plateInfo.type ?? 'N/A'
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget ViolationRegisteredRules(){
  return Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.black12
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TemplateHeadlineText('Overtredelse'),
        12.h,
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              ...widget.violation.rules.map((e){
                return InfoBlock(
                titleText: 'Overtredelse 1', 
                blockValue: e.name
              );
              })
            ],
          ),
        )
      ],
    ),
  );
}

Widget ViolationMainData(){
  return Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.black12
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TemplateHeadlineText('Kontrollsanksjon'),
        12.h,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoBlock(
                titleText: 'Ticket Id', 
                blockValue: widget.violation.ticketNumber ?? 'N/A'
              ),
              InfoBlock(
                titleText: 'KID number',  
                blockValue: '00666465466'
              ),
              Row(
                children: [
                  Expanded(
                    child: InfoBlock(
                      titleText: 'Fra', 
                      blockValue: '19.12.23 19:01'
                    ),
                  ),
                  Expanded(
                    child: InfoBlock(
                      titleText: 'Til', 
                      blockValue: '19.12.23 19:11'
                    ),
                  ),
                ],
              ),

              InfoBlock(
                titleText: 'Belop', 
                blockValue: widget.violation.rules.map((e){
                  return e.charge;
                }).reduce((value, element) => value + element).toString() + ' Kr'
              ),

              Row(
                children: [
                  Expanded(
                    child: InfoBlock(
                      titleText: 'Betalingsfrist', 
                      blockValue: '09.01.24'
                    ),
                  ),
                  Expanded(
                    child: InfoBlock(
                      titleText: 'Levering', 
                      blockValue: 'Kjoretoy'
                    ),
                  ),
                ],
              ),

              InfoBlock(
                titleText: 'Registered by', 
                blockValue: widget.violation.user.identifier ?? 'N/A'
              )
            ],
          ),
        )
      ],
    ),
  );
}



Widget PrintWidget(){
  return SingleChildScrollView(
    child: Container(
      height: 2200,
      padding: EdgeInsets.all(12.0),
      child: widget.violation.printPaper != null ? Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(widget.violation.printPaper!),
            fit: BoxFit.contain,
            // filterQuality: FilterQuality.high
          ),
        ),
      ) : EmptyDataContainer(
        text: 'No Image',
      ),
    ),
  );
}

}

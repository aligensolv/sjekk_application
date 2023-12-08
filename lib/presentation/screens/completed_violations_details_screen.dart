import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/core/constants/app_images.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import '../../data/models/rule_model.dart';
import '../../data/models/violation_model.dart';
import '../widgets/template/components/template_image.dart';
import '../widgets/template/components/template_text_field.dart';
import 'gallery_view.dart';

class CompletedViolationDetailsScreen extends StatefulWidget {
  final Violation violation;

  const CompletedViolationDetailsScreen({Key? key, required this.violation}) : super(key: key);

  @override
  State<CompletedViolationDetailsScreen> createState() => _CompletedViolationDetailsScreenState();
}

class _CompletedViolationDetailsScreenState extends State<CompletedViolationDetailsScreen> {
          final TextEditingController innerController = TextEditingController();
        final TextEditingController outterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final violationDetailsProvider = Provider.of<ViolationDetailsProvider>(context,listen: false);
    innerController.text = violationDetailsProvider.violation.paperComment;
    outterController.text = violationDetailsProvider.violation.outComment;
  }

  @override
  void dispose() {
    innerController.dispose();
    outterController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
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
                icon: Icon(Icons.image),
              ),
              Tab(
                icon: Icon(Icons.rule),
              ),
              Tab(
                icon: Icon(Icons.comment),
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
                  ImagesWidget(),
                  RulesWidget(),
                  CommentsWidget(),
                  PrintWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget CommentsWidget(){
    return Consumer<ViolationDetailsProvider>(
      builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) {  
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TemplateHeadlineText('Inline Paper Comment'),
              8.h,
              NormalTemplateTextField(
                hintText: 'Inner Comment',
                lines: 5,
                isReadOnly: true,
                controller: innerController,
              ),
              12.h,
              TemplateHeadlineText('Ohter Comment'),
              8.h,
              NormalTemplateTextField(
                hintText: 'Outter Comment',
                lines: 5,
                isReadOnly: true,
                controller: outterController,
              ),
            ],
          ),
        );
      },
    );
  }

Widget CarInfoWidget() {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TemplateContainerCard(
            title: widget.violation.plateInfo.plate,
            backgroundColor: widget.violation.is_car_registered ? Colors.blue : Colors.red,
          ),
          12.h,
                              _buildInfoContainer('Type', widget.violation.plateInfo.type),
          _buildInfoContainer('Status', widget.violation.status),
          _buildInfoContainer('Brand', widget.violation.plateInfo.brand),
          _buildInfoContainer('Year', widget.violation.plateInfo.year),
          _buildInfoContainer('Description', widget.violation.plateInfo.description),
          _buildInfoContainer('Created At', widget.violation.createdAt),
    
          if(widget.violation.is_car_registered && widget.violation.registeredCar != null)
          Column(
            children: [
              TemplateHeadlineText('More Information'),
              12.h,
              _buildInfoContainer('Regiseration type', widget.violation.registeredCar!.registerationType),
              _buildInfoContainer('Fra', widget.violation.registeredCar!.startDate),
              _buildInfoContainer('Regiseration type', widget.violation.registeredCar!.endDate)
            ],
          )
        ],
      ),
    ),
  );
}

Widget _buildInfoContainer(String title, String value) {
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
          child: const Icon(Icons.info_outline,size: 30,color: Colors.white,),
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
                value,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget ImagesWidget(){
  return Consumer<ViolationDetailsProvider>(
    builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) {  
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
                      
                        itemCount: violationDetailsProvider.violation.carImages.length,
                      itemBuilder: (context,index){
                        return TemplateNetworkImageContainer(
                          path: violationDetailsProvider.violation.carImages[index].path,
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => TemplateGalleryViewScreen(
                                images: violationDetailsProvider.violation.carImages, 
                                initialIndex: index,
                                gallerySource: GallerySource.network,
                              ))
                            );
                          },
                        );
                      },
                      
                    ),
        ),
      ],
    ),
  );
    },
  );
}

Widget RulesWidget(){
  return Consumer<ViolationDetailsProvider>(
    builder: (BuildContext context, ViolationDetailsProvider violationDetailsProvider, Widget? child) { 
          return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: violationDetailsProvider.violation.rules.length,
              itemBuilder: ((context, index) {
                Rule rule = violationDetailsProvider.violation.rules[index];
                return GestureDetector(
                  onTap: (){
          
                  },
                  child: TemplateTileContainerCardWithExpandedIcon(
                    title: '${rule.name} (${rule.charge} \$)',
                    icon: Icons.euro,
                  ),
                );
              }),
            ),
          ),

        ],
      ),
    );
    },
  );
}

Widget PrintWidget(){

  final media = MediaQuery.of(context).size;

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

/**
 Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.0,),
              if(widget.violation.stat`us == 'saved')
              Align(
                alignment: Alignment.centerRight,
                child: NormalTemplateButton(
                  text: 'Print And Complete',
                  onPressed: (){

                  },
                ),
              ),
              SizedBox(height: 24,),
              if(DateTime.now().difference(parsedCreatedAt).inMinutes < 6)
              TemplateHeadlineText(
                'Time passed: ${DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().difference(parsedCreatedAt).inMilliseconds))}'
              ),
              
              SizedBox(height: 12),
              Text(
                'Place: ${widget.violation.place.location}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
            Text(
              'Policy: ${widget.violation.place.policy}',
              style: TextStyle(fontSize: 16),
            ),
              SizedBox(height: 12),
              Text(
                'Rules:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...widget.violation.rules.map((rule) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('- ${rule.name} -> ${rule.charge}', style: TextStyle(fontSize: 16)),
                  )),
              SizedBox(height: 12),
              Text(
                'Car Images:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              // You can use a widget to display the car images, such as a ListView.builder.
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0
                ),
                itemCount: widget.violation.carImages.length,
                itemBuilder: (context, index) {
                  return Image.network(widget.violation.carImages[index],fit: BoxFit.cover,);
                },
              ),
            ],
          ),
        ),
      )
 */
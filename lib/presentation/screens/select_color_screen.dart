import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/models/car_type_model.dart';
import 'package:sjekk_application/data/models/color_model.dart';
import 'package:sjekk_application/presentation/providers/car_type_provider.dart';
import 'package:sjekk_application/presentation/providers/color_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/empty_data_container.dart';

import '../providers/violation_details_provider.dart';

class SelectCarColorScreen extends StatefulWidget {
  static const String route = "SelectCarColorScreen";
  const SelectCarColorScreen({super.key});

  @override
  State<SelectCarColorScreen> createState() => _SelectCarColorScreenState();
}

class _SelectCarColorScreenState extends State<SelectCarColorScreen> {
  @override
  void initState() {
    super.initState();
    initializeColors();
  }

  void initializeColors() async{
    await Provider.of<ColorProvider>(context, listen: false).getAllColors();
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
                icon: Icons.search, 
                hintText: 'search',
                onChanged: (val){
                  context.read<ColorProvider>().searchColors(val);
                },
              ),
              12.h,
              Expanded(
                child: Consumer<ColorProvider>(
                  builder: (BuildContext context, ColorProvider colorProvider, Widget? child) { 
                    if(colorProvider.colors.isEmpty){
                      return Center(
                        child: EmptyDataContainer(
                          text: 'No Colors Found',
                        ),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context,index){
                        return const SizedBox(height: 12,);
                      },
                      itemBuilder: (context, index) {
                        CarColor color = colorProvider.colors[index];
                        return TemplateContainerCard(
                          title: color.value,
                          backgroundColor: primaryColor,
                          onTap: () async{
                            await context.read<ViolationDetailsProvider>().changeViolationColor(color);
                            Navigator.pop(context);
                          },
                        );
                      },
                      itemCount: colorProvider.colors.length,  
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/models/car_type_model.dart';
import 'package:sjekk_application/presentation/providers/car_type_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/empty_data_container.dart';

import '../providers/violation_details_provider.dart';

class SelectCarTypeScreen extends StatefulWidget {
  static const String route = "SelectCarTypeScreen";
  const SelectCarTypeScreen({super.key});

  @override
  State<SelectCarTypeScreen> createState() => _SelectCarTypeScreenState();
}

class _SelectCarTypeScreenState extends State<SelectCarTypeScreen> {
  @override
  void initState() {
    super.initState();
    initializeTypes();
  }

  void initializeTypes() async{
    await Provider.of<CarTypeProvider>(context, listen: false).getAllCarTypes();
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
                  context.read<CarTypeProvider>().searchTypes(val);
                },
              ),
              12.h,
              Expanded(
                child: Consumer<CarTypeProvider>(
                  builder: (BuildContext context, CarTypeProvider carTypeProvider, Widget? child) { 
                    if(carTypeProvider.carTypes.isEmpty){
                      return Center(
                        child: EmptyDataContainer(
                          text: 'No Types Found',
                        ),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context,index){
                        return const SizedBox(height: 12,);
                      },
                      itemBuilder: (context, index) {
                        CarType type = carTypeProvider.carTypes[index];
                        return TemplateContainerCard(
                          title: type.value,
                          backgroundColor: primaryColor,
                          onTap: () async{
                            await context.read<ViolationDetailsProvider>().changeViolationType(type);
                            Navigator.pop(context);
                          },
                        );
                      },
                      itemCount: carTypeProvider.carTypes.length,  
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
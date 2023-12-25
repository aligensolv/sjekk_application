import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/models/car_type_model.dart';
import 'package:sjekk_application/presentation/providers/brand_provider.dart';
import 'package:sjekk_application/presentation/providers/car_type_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text_field.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'package:sjekk_application/presentation/widgets/template/widgets/empty_data_container.dart';

import '../../data/models/brand_model.dart';
import '../providers/local_violation_details_provider.dart';
import '../providers/violation_details_provider.dart';

class LocalSelectCarBrandScreen extends StatefulWidget {
  static const String route = "LocalSelectCarBrandScreen";
  const LocalSelectCarBrandScreen({super.key});

  @override
  State<LocalSelectCarBrandScreen> createState() => _LocalSelectCarBrandScreenState();
}

class _LocalSelectCarBrandScreenState extends State<LocalSelectCarBrandScreen> {
  @override
  void initState() {
    super.initState();
    initializeBrands();
  }

  void initializeBrands() async{
    await Provider.of<BrandProvider>(context, listen: false).getAllBrands();
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
                  context.read<BrandProvider>().searchBrands(val);
                },
              ),
              12.h,
              Expanded(
                child: Consumer<BrandProvider>(
                  builder: (BuildContext context, BrandProvider brandProvider, Widget? child) { 
                    if(brandProvider.brands.isEmpty){
                      return Center(
                        child: EmptyDataContainer(
                          text: 'No Brands Found',
                        ),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context,index){
                        return const SizedBox(height: 12,);
                      },
                      itemBuilder: (context, index) {
                        Brand brand = brandProvider.brands[index];
                        return TemplateContainerCard(
                          title: brand.value,
                          backgroundColor: primaryColor,
                          onTap: () async{
                            await context.read<LocalViolationDetailsProvider>().changeViolationBrand(brand);
                            Navigator.pop(context);
                          },
                        );
                      },
                      itemCount: brandProvider.brands.length,  
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
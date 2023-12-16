import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/repositories/remote/violation_repository.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../providers/violation_details_provider.dart';
import '../widgets/template/components/template_button.dart';
import '../widgets/template/components/template_image.dart';
import 'gallery_view.dart';

class CompletedViolationImages extends StatefulWidget {
  static const String route = "completed_violations_images";
  const CompletedViolationImages({super.key});

  @override
  State<CompletedViolationImages> createState() => _CompletedViolationImagesState();
}

class _CompletedViolationImagesState extends State<CompletedViolationImages> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Consumer<ViolationDetailsProvider>(
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

                12.h,

        NormalTemplateButton(
          text: 'ADD IMAGE',
          width: double.infinity,
          backgroundColor: secondaryColor,
          onPressed: () async{
            ImagePicker imagePicker = ImagePicker();
            XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
            if(file != null){
              await violationDetailsProvider.uploadImage(file.path);
            }
          },
        )
      ],
    ),
  );
    },
  ),
      ),
    );
  }
}
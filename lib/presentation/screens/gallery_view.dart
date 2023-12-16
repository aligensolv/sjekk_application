import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sjekk_application/data/models/car_image_model.dart';

enum GallerySource{
  asset,
  file,
  network
}

class TemplateGalleryViewScreen extends StatefulWidget {
  final List<CarImage> images;
  final int initialIndex;
  final GallerySource gallerySource;
  TemplateGalleryViewScreen({
    super.key, 
    required this.images, 
    required this.gallerySource,
    this.initialIndex = 0,
  });

  @override
  State<TemplateGalleryViewScreen> createState() => _TemplateGalleryViewScreenState();
}

class _TemplateGalleryViewScreenState extends State<TemplateGalleryViewScreen> {
  PageController? controller;
  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: widget.initialIndex
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: PhotoViewGallery.builder(
        itemCount: widget.images.length,
        pageController: controller,
        loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
        builder: (BuildContext context, int index){
          ImageProvider provider;
          if(widget.gallerySource == GallerySource.file){
            File file = File(widget.images[index].path);
            provider = FileImage(file);
          }else if(widget.gallerySource == GallerySource.asset){
            provider = AssetImage(widget.images[index].path);
          }else {
            provider = CachedNetworkImageProvider(widget.images[index].path);
          }

          return PhotoViewGalleryPageOptions(

            imageProvider: provider,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(
              tag: widget.images[index].path
            )
          );
        }
      ),
    );
  }
}
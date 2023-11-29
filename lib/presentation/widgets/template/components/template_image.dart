import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TemplateAssetImageContainer extends StatelessWidget {
  final String path;
  const TemplateAssetImageContainer({super.key,required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.black12
        ),
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover
        )
      ),
    );
  }
}
class TemplateNetworkImageContainer extends StatelessWidget {
  final String path;
  final VoidCallback? onTap;

  const TemplateNetworkImageContainer({super.key,required this.path, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.black12
          ),
          image: DecorationImage(
            image: CachedNetworkImageProvider(path),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}


class TemplateFileImageContainer extends StatelessWidget {
  final String path;
  final VoidCallback? onTap;
  const TemplateFileImageContainer({super.key,required this.path, this.onTap});

  @override
  Widget build(BuildContext context) {
    final File file = File(path);
    return InkWell(
      onTap: onTap,
      child: Hero(
        tag: path,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.black12
            ),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover
            )
          ),
        ),
      ),
    );
  }
}
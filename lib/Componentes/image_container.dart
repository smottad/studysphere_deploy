import 'dart:io';

import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer(
    {
      super.key,
      required this.asset,
      this.assetImage,
      this.image,
    }
  );

  final bool asset;
  final String? assetImage;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),                   
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: asset ? Image.asset(
          assetImage!,
          fit: BoxFit.cover,
        ) : Image(
          image: image!.image,

          fit: BoxFit.cover,
        ),
      ), 
    );
  }
}
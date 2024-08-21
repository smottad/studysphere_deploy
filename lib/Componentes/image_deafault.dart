import 'package:flutter/material.dart';

class ImageDefault extends StatelessWidget {
  const ImageDefault({
    super.key,
    required this.pathImage,
    required this.colorScheme,
  });

  final String pathImage;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage(pathImage),
      backgroundColor: colorScheme.secondaryContainer,
      radius: (MediaQuery.of(context).size.height * 0.07).clamp(10, 100),
    );
  }
}
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

import '../custom_image_viewer.dart';

class AnimatedOverlay extends StatelessWidget {
  const AnimatedOverlay({super.key, required this.topPos, required this.leftPos, required this.assetImage, required this.blurValue, required this.imageHeight, required this.imageWidth});
  final double topPos;
  final double leftPos;
  final String assetImage;
  final double blurValue;
  final double imageHeight;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: topPos,
        left: leftPos,
        height: imageHeight,
        width: imageWidth,
        child: TransparentPointer(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10.1 - (blurValue * 10.0), sigmaY: 10.1 - (blurValue * 10.0)),
            child: Image.asset(
              assetImage,
              height: overlayImageHeight,
              width: overlayImageWidth,
            ),
          ),
        ));
  }
}

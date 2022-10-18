import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:eyris_portfolio/utils/my_assets.dart';

class SmallImage extends StatelessWidget {
  const SmallImage({
    Key? key,
    required this.imagePath,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
  }) : super(key: key);
  final String imagePath;
  final Function(PointerEnterEvent detail) onEnter;
  final Function(PointerExitEvent detail) onExit;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: onEnter,
        onExit: onExit,
        child: SizedBox(
          height: 100,
          width: 200,
          child: Image.asset(
            imagePath,
            height: 100,
            width: 200,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}

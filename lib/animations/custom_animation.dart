import 'dart:ui';

import 'package:flutter/material.dart';

class BackDropRoute extends PageRouteBuilder {
  final Widget currentWidget;
  final Widget newWidget;

  BackDropRoute({required this.currentWidget, required this.newWidget})
      : super(
            transitionDuration: const Duration(milliseconds: 600),
            reverseTransitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return newWidget;
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              int highSigma = 300;
              return Stack(
                children: <Widget>[
                  if (animation.value < 0.5)
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: (highSigma * (animation.value)) + 0.1, sigmaY: (highSigma * (animation.value)) + 0.1),
                      child: currentWidget,
                    ),
                  if (animation.value > 0.5)
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: (highSigma * (1 - animation.value)) + 0.1, sigmaY: (highSigma * (1 - animation.value)) + 0.1),
                      child: newWidget,
                    ),
                ],
              );
            });
}

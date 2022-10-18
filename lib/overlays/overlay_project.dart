import 'dart:ui';

import 'package:eyris_portfolio/widgets/custom_image_viewer/custom_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/model_project_card.dart';

class OverlayProject extends StatefulWidget {
  const OverlayProject({super.key, required this.modelProjectCard, required this.topOffset, required this.leftOffset, required this.size, required this.onDismiss});
  final ModelProjectCard modelProjectCard;
  final double topOffset;
  final double leftOffset;
  final Size size;
  final Function() onDismiss;
  @override
  State<OverlayProject> createState() => _OverlayProjectState();
}

class _OverlayProjectState extends State<OverlayProject> with TickerProviderStateMixin {
  late final AnimationController iconAnimation;
  late Animation<double> topOffsetAnimation;
  late Animation<double> leftOffsetAnimation;

  late final AnimationController backgroundAnimation;
  late Animation<double> heightAnimation;
  late Animation<double> widthAnimation;

  final ValueNotifier<bool> isContentVisible = ValueNotifier(false);

  bool isInit = false;
  @override
  void initState() {
    super.initState();
    iconAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 300), reverseDuration: const Duration(milliseconds: 200));
    backgroundAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 300), reverseDuration: const Duration(milliseconds: 200));
    iconAnimation.forward().then((value) {
      backgroundAnimation.forward().then((value) {
        isContentVisible.value = true;
      });
    });

    isInit = true;
  }

  @override
  void didChangeDependencies() {
    final Size size = MediaQuery.of(context).size;
    if (isInit) {
      topOffsetAnimation = Tween<double>(begin: widget.topOffset, end: size.height * 0.13).animate(iconAnimation);
      leftOffsetAnimation = Tween<double>(begin: widget.leftOffset, end: (size.width * 0.5) - (widget.size.width * 0.5)).animate(iconAnimation);

      final double calculatdWidth = size.width * 0.4 < 350 ? 350 : size.width * 0.6;
      heightAnimation = Tween<double>(begin: widget.size.height, end: size.height * 0.85).animate(backgroundAnimation);
      widthAnimation = Tween<double>(begin: widget.size.width, end: calculatdWidth).animate(backgroundAnimation);
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void onDismiss() async {
    isContentVisible.value = false;
    await backgroundAnimation.reverse();
    await iconAnimation.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Positioned.fill(
        child: Stack(
      children: [
        Positioned.fill(
            child: GestureDetector(
          onTap: onDismiss,
          child: Container(
            color: Colors.black.withOpacity(0.1),
          ),
        )),
        AnimatedBuilder(
            animation: backgroundAnimation,
            builder: (context, _) {
              return Positioned(
                  top: size.height * 0.13 - (widget.size.height * 0.5),
                  left: (size.width * 0.5) - (widthAnimation.value * 0.5),
                  height: heightAnimation.value,
                  width: widthAnimation.value,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: widthAnimation.value,
                      height: heightAnimation.value,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2 * backgroundAnimation.value), borderRadius: BorderRadius.circular(10)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: (10 * backgroundAnimation.value) + 0.1, sigmaY: (10 * backgroundAnimation.value) + 0.1),
                        child: Material(
                          color: Colors.transparent,
                          child: ValueListenableBuilder<bool>(
                              valueListenable: isContentVisible,
                              builder: (context, isContentVisible, _) {
                                if (!isContentVisible) return const SizedBox();
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: widget.size.height + 10 + size.height * 0.05,
                                    ),
                                    Text(widget.modelProjectCard.fullDescription, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 22)),
                                    Expanded(
                                        child: CustomImageViewer(
                                      images: widget.modelProjectCard.listOfImages,
                                    ))
                                  ],
                                );
                              }),
                        ),
                      ),
                    ),
                  ));
            }),
        AnimatedBuilder(
            animation: iconAnimation,
            builder: (context, _) {
              return Positioned(
                  top: topOffsetAnimation.value,
                  left: leftOffsetAnimation.value,
                  height: widget.size.height,
                  width: widget.size.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        widget.modelProjectCard.projectIcon,
                        height: widget.size.height,
                        width: widget.size.width,
                      )));
            }),
      ],
    ));
  }
}

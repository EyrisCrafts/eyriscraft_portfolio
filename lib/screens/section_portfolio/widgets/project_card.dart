import 'dart:ui';

import 'package:eyris_portfolio/models/model_project_card.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.modelProjectCard, required this.onSelected});
  final ModelProjectCard modelProjectCard;
  final Function(ModelProjectCard modelProjectCard, double topOffset, double leftOffset, Size size) onSelected;

  @override
  State<ProjectCard> createState() => ProjectCardState();
}

class ProjectCardState extends State<ProjectCard> with TickerProviderStateMixin {
  late final AnimationController initialAnimation;
  late final AnimationController hoverAnimation;
  late Animation<Color?> hoverColorAnimation;
  final GlobalKey iconKey = GlobalKey();

  final ValueNotifier<bool> isIconVisible = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    initialAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    initialAnimation.forward();
    hoverAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    hoverColorAnimation = ColorTween(begin: Colors.white.withOpacity(0.1), end: Colors.white.withOpacity(0.3)).animate(
      CurvedAnimation(
        parent: hoverAnimation,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    initialAnimation.dispose();
    hoverAnimation.dispose();
    super.dispose();
  }

  void enableIcon() {
    isIconVisible.value = true;
  }

  void onTap() {
    // Get icon locatoin

    // Hide icon
    isIconVisible.value = false;
    final renderBox = iconKey.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    widget.onSelected(widget.modelProjectCard, offset.dy, offset.dx, size);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.maxFinite,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 30),
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) {
            hoverAnimation.forward();
          },
          onExit: (event) {
            hoverAnimation.reverse();
          },
          child: Container(
            height: 150,
            width: calculateMaxWidth(size.width),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
            ),
            child: SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: AnimatedBuilder(
                            animation: initialAnimation,
                            builder: (context, _) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: -5 * (initialAnimation.value + 0.1), sigmaY: 20 * (initialAnimation.value + 0.1)),
                                child: AnimatedBuilder(
                                    animation: hoverAnimation,
                                    builder: (context, _) {
                                      return Container(
                                        height: double.maxFinite,
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          color: !hoverAnimation.isDismissed ? hoverColorAnimation.value : Colors.white.withOpacity(0.1 * initialAnimation.value),
                                        ),
                                      );
                                    }),
                              );
                            }),
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.modelProjectCard.title, style: TextStyle(color: Colors.white.withOpacity(0.75), fontWeight: FontWeight.w600, fontSize: 25)),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(widget.modelProjectCard.smallDescription, style: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500, fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                      animation: initialAnimation,
                      builder: (context, _) {
                        final double quickerValue = initialAnimation.value > 0.5 ? 1.0 : initialAnimation.value * 2.0;
                        return Positioned(
                            bottom: -25 * quickerValue,
                            right: -25 * quickerValue,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ValueListenableBuilder<bool>(
                                    valueListenable: isIconVisible,
                                    builder: (context, isIconVisible, _) {
                                      if (!isIconVisible) {
                                        return const SizedBox(
                                          height: 70,
                                          width: 70,
                                        );
                                      }
                                      return Image.asset(
                                        widget.modelProjectCard.projectIcon,
                                        key: iconKey,
                                        height: 70 * quickerValue,
                                        width: 70 * quickerValue,
                                      );
                                    })));
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double calculateMaxWidth(double screenWidth) {
    if (screenWidth * 0.4 < 350) return 350;
    return screenWidth * 0.4;
  }
}

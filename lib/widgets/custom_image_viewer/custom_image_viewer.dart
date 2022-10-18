import 'dart:ui';

import 'package:eyris_portfolio/widgets/custom_image_viewer/widgets/animated_overlay.dart';
import 'package:eyris_portfolio/widgets/custom_image_viewer/widgets/image_viewer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

const double overlayImageHeight = 200;
const double overlayImageWidth = 400;

const double originalImageHeight = 100;
const double originalImageWidth = 200;

class CustomImageViewer extends StatefulWidget {
  const CustomImageViewer({super.key, required this.images});
  final List<String> images;

  @override
  State<CustomImageViewer> createState() => _CustomImageViewerState();
}

class _CustomImageViewerState extends State<CustomImageViewer> with TickerProviderStateMixin {
  int numberOfImages = 12;
  late final List<GlobalKey> keys;
  late final List<String> images;

  GlobalKey keyStack = GlobalKey();
  double leftPos = 0;
  double topPos = 0;
  String image = "";

  late final AnimationController _blurController;
  late final AnimationController _sizeController;

  late final AnimationController _mainBlurController;

  final ValueNotifier<String> _selectedImage = ValueNotifier("");

  Future? _blurAnimationFuture;
  Future? _sizeAnimationFuture;

  Future? customFuture;
  Size? screenSize;

  @override
  void initState() {
    super.initState();
    numberOfImages = widget.images.length;
    images = widget.images;
    keys = List.generate(numberOfImages, (index) => GlobalKey());

    _blurController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _sizeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _mainBlurController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _selectedImage.value = images.first;
  }

  @override
  void didChangeDependencies() {
    screenSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, stackConstraints) {
      return Stack(
        key: keyStack,
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: stackConstraints.maxWidth * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Text("Dota 2 Wallpapers", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black)),
                  const SizedBox(
                    height: 50,
                  ),
                  LayoutBuilder(builder: (context, constraints) {
                    return ValueListenableBuilder(
                        valueListenable: _selectedImage,
                        builder: (context, selectedImage, _) => AnimatedBuilder(
                            animation: _mainBlurController,
                            child: Image.asset(
                              selectedImage,
                              width: constraints.maxWidth * 0.5,
                              height: constraints.maxWidth * 0.5 * 0.5,
                            ),
                            builder: (context, child) {
                              return ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: 10.1 - ((1 - _mainBlurController.value) * 10.0), sigmaY: 10.1 - ((1 - _mainBlurController.value) * 10.0)),
                                child: child,
                              );
                            }));
                  }),
                  const SizedBox(
                    height: 50,
                  ),
                  Wrap(
                    children: List.generate(
                      numberOfImages,
                      (index) => SmallImage(
                        key: keys[index],
                        imagePath: images[index],
                        onEnter: (PointerEnterEvent detail) => onEnter(keys[index], images[index]),
                        onExit: (PointerExitEvent detail) => onExit(),
                        onTap: () => updateImage(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ImageViewer Overlay that stays there
          AnimatedBuilder(
              animation: _sizeController,
              builder: (context, _) {
                if (image.isEmpty) return const SizedBox();

                return AnimatedBuilder(
                  builder: (context, _) {
                    return AnimatedOverlay(
                      topPos: topPos - (_sizeController.value * originalImageHeight),
                      leftPos: leftPos - (_sizeController.value * originalImageWidth),
                      assetImage: image,
                      blurValue: _blurController.value,
                      imageHeight: overlayImageHeight * _sizeController.value,
                      imageWidth: overlayImageWidth * _sizeController.value,
                    );
                  },
                  animation: _blurController,
                );
              })
        ],
      );
    });
  }

  double getTotalOffset() {
    try {
      RenderBox renderBox = keyStack.currentContext?.findRenderObject() as RenderBox;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      return offset.dy;
    } catch (e) {
      return 0;
    }
  }

  void updateImage(int selectedIndex) async {
    await _mainBlurController.forward().then((value) => null);
    _selectedImage.value = images[selectedIndex];
    await _mainBlurController.reverse().then((value) => null);
  }

  void onEnter(GlobalKey key, String image) async {
    RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    // What if animation in progress
    if (_blurController.isAnimating && _blurAnimationFuture != null) {
      await _blurAnimationFuture;
    }
    if (_sizeController.isAnimating && _sizeAnimationFuture != null) {
      await _sizeAnimationFuture;
    }
    if (_sizeController.isAnimating || _sizeController.isCompleted) {
      _sizeController.reset();
      _sizeController.value = 0;
      _blurController.reset();
      _blurController.value = 0;
    }
    if (_blurController.isAnimating || _blurController.isCompleted) {
      _sizeController.reset();
      _sizeController.value = 0;
      _blurController.reset();
      _blurController.value = 0;
    }

    this.image = image;

    // Center the overlay
    leftPos = offset.dx + (originalImageWidth / 2);
    topPos = offset.dy + (originalImageHeight / 2) - getTotalOffset();

    // Adjusting for Global Offset
    if (screenSize != null) {
      final double totalBoxWidth = screenSize!.width * 0.4 < 350 ? 350 : screenSize!.width * 0.6;
      leftPos = leftPos - (totalBoxWidth * 0.8 * 0.5) + (originalImageWidth * 0.5);
    }

    //Begin Size animation
    try {
      _sizeAnimationFuture = _sizeController.forward(from: 0).then((value) {
        _blurAnimationFuture = _blurController.forward(from: 0).then((value) => null);
      });
    } catch (e) {
      print("Error");
    }
  }

  void onExit() async {
    if (_blurController.isAnimating && _blurAnimationFuture != null) {
      await _blurAnimationFuture;
    }
    if (_sizeController.isAnimating && _sizeAnimationFuture != null) {
      await _sizeAnimationFuture;
    }
    if (_blurController.isCompleted || _sizeController.isCompleted) {
      _blurAnimationFuture = _blurController.reverse().then((value) {
        _sizeAnimationFuture = _sizeController.reverse().then((value) => null);
      });
    }
  }

  @override
  void dispose() {
    _blurController.dispose();
    _sizeController.dispose();
    super.dispose();
  }
}

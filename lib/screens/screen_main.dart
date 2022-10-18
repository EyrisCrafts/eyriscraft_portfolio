import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:eyris_portfolio/animations/custom_animation.dart';
import 'package:eyris_portfolio/screens/screen_second.dart';
import 'package:eyris_portfolio/screens/section_portfolio/section_portfolio.dart';
import 'package:eyris_portfolio/utils/my_assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

import '../widgets/custom_image_viewer/widgets/image_viewer.dart';
import '../widgets/my_button.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

const double overlayImageHeight = 200;
const double overlayImageWidth = 400;

const double originalImageHeight = 100;
const double originalImageWidth = 200;

class _ScreenMainState extends State<ScreenMain> with TickerProviderStateMixin {
  static const numberOfImages = 12;
  List<GlobalKey> keys = List.generate(numberOfImages, (index) => GlobalKey());
  List<String> images = List.generate(numberOfImages, (index) => "assets/image_$index.jpg");
  double leftPos = 0;
  double topPos = 0;
  String image = "";
  late final AnimationController _blurController;
  late final AnimationController _sizeController;

  // Blur controller for selected Image
  late final AnimationController _mainBlurController;

  final ValueNotifier<String> _selectedImage = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    _blurController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _sizeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _mainBlurController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _selectedImage.value = images.first;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.srcOver), image: const AssetImage(MyAssets.backgroundImage), fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width,
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(onTap: () {}, title: "ABOUT ME"),
              MyButton(onTap: () {}, title: "PORTFOLIO"),
            ],
          ),
          const Expanded(child: SectionPortfolio())
        ],
      ),
    ));
    //     body: Center(
    //         child: Stack(
    //   children: [
    //     Align(
    //       alignment: Alignment.center,
    //       child: SizedBox(
    //         width: size.width * 0.7,
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             const Text("Dota 2 Wallpapers", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black)),
    //             const SizedBox(
    //               height: 50,
    //             ),
    //             LayoutBuilder(builder: (context, constraints) {
    //               return ValueListenableBuilder(
    //                   valueListenable: _selectedImage,
    //                   builder: (context, selectedImage, _) => AnimatedBuilder(
    //                       animation: _mainBlurController,
    //                       child: Image.asset(
    //                         selectedImage,
    //                         width: constraints.maxWidth * 0.5,
    //                         height: constraints.maxWidth * 0.5 * 0.5,
    //                       ),
    //                       builder: (context, child) {
    //                         return ImageFiltered(
    //                           imageFilter: ImageFilter.blur(sigmaX: 10.01 - ((1 - _mainBlurController.value) * 10.0), sigmaY: 10.01 - ((1 - _mainBlurController.value) * 10.0)),
    //                           child: child,
    //                         );
    //                       }));
    //             }),
    //             const SizedBox(
    //               height: 50,
    //             ),
    //             Wrap(
    //               children: List.generate(
    //                 numberOfImages,
    //                 (index) => SmallImage(
    //                   key: keys[index],
    //                   imagePath: images[index],
    //                   onEnter: (PointerEnterEvent detail) => onEnter(keys[index], images[index]),
    //                   onExit: (PointerExitEvent detail) => onExit(),
    //                   onTap: () => updateImage(index),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),

    //     // ImageViewer Overlay that stays there
    //     AnimatedBuilder(
    //         animation: _sizeController,
    //         builder: (context, _) {
    //           if (image.isEmpty) return const SizedBox();

    //           return AnimatedBuilder(
    //             builder: (context, _) {
    //               return AnimatedOverlay(
    //                 topPos: topPos - (_sizeController.value * originalImageHeight),
    //                 leftPos: leftPos - (_sizeController.value * originalImageWidth),
    //                 assetImage: image,
    //                 blurValue: _blurController.value,
    //                 imageHeight: overlayImageHeight * _sizeController.value,
    //                 imageWidth: overlayImageWidth * _sizeController.value,
    //               );
    //             },
    //             animation: _blurController,
    //           );
    //         })
    //   ],
    // )));
  }

  void updateImage(int selectedIndex) async {
    await _mainBlurController.forward().then((value) => null);
    _selectedImage.value = images[selectedIndex];
    await _mainBlurController.reverse().then((value) => null);
  }

  Future? _blurAnimationFuture;
  Future? _sizeAnimationFuture;

  Future? customFuture;

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
    topPos = offset.dy + (originalImageHeight / 2);
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

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class AnimatedCardWrapper extends StatefulWidget {
//   const AnimatedCardWrapper({super.key, required this.child});
//   final Widget child;
//   @override
//   State<AnimatedCardWrapper> createState() => _AnimatedCardWrapperState();
// }

// class _AnimatedCardWrapperState extends State<AnimatedCardWrapper> with SingleTickerProviderStateMixin {
//   late final AnimationController animationController;

//   @override
//   void initState() {
//     super.initState();
//     animationController = AnimationController(vsync: this, duration: const Duration(
//       milliseconds: 300
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animationController,
//       child: widget.child,
//     );
//   }
// }

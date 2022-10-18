import 'package:eyris_portfolio/utils/my_colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  const MyButton({super.key, required this.title, required this.onTap});
  final String title;
  final Function() onTap;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: MyColors.primaryColor.withOpacity(_animationController.value), borderRadius: BorderRadius.circular(4)),
                  child: Text(widget.title, style: const TextStyle(color: Colors.white)),
                );
              })),
    );
  }

  void _onEnter(_) {
    _animationController.forward();
  }

  void _onExit(_) {
    _animationController.reverse();
  }
}

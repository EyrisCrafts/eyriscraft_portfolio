import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScreenSecond extends StatefulWidget {
  const ScreenSecond({super.key, required this.assetString});
  final String assetString;
  @override
  State<ScreenSecond> createState() => _ScreenSecondState();
}

class _ScreenSecondState extends State<ScreenSecond> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            // child: Text("Back"),
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            widget.assetString,
            height: size.width * 0.35,
            width: size.width * 0.7,
          ),
        ],
      ),
    );
  }
}

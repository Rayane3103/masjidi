import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFF06433D);
Color secondaryColor = const Color(0xFFC88826);



class MySpace extends StatelessWidget {
  final double? height;
  final double? width;
  const MySpace({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height: height,
    width: width,);
  }
}
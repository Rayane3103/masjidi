import 'package:flutter/material.dart';
import 'package:masjidi/Constants/constants.dart';

class CustomPageIndicator extends StatelessWidget {
  final int selectedIndex;
  final int itemCount;

  const CustomPageIndicator({
    Key? key,
    required this.selectedIndex,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the indicator row
      children: List.generate(itemCount, (index) {
        if (index == selectedIndex) {
          // Selected index (rounded rectangle)
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 20.0, // Adjust the width of the rectangle
            height: 5.0,
            decoration: BoxDecoration(
              color: primaryColor, // Selected color
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
            ),
          );
        } else {
          // Other indexes (circle)
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 8.0,
            height: 7.0,
            decoration: BoxDecoration(
              color: Colors.grey, // Unselected color
              shape: BoxShape.circle,
            ),
          );
        }
      }),
    );
  }
}
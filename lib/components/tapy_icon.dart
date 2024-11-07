import 'package:flutter/material.dart';
import 'package:masjidi/Constants/constants.dart';

class TappyIcon extends StatelessWidget {
  final String path;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  const TappyIcon({
    Key? key,
    required this.path,
    required this.label,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.height * 0.08,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
              color: isSelected? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              path,
              
              color: isSelected ? Colors.white : primaryColor,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.016,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : Colors.black,
          ),
        )
      ],
    );
  }
}
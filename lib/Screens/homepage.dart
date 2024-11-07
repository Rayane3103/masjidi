import 'package:flutter/material.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/alldetails_page.dart';
import 'package:masjidi/components/pub.dart';

class HomePage extends StatelessWidget {
   final Map<String, dynamic>? resultData;

 const HomePage({super.key, required this.resultData});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
 final mosqueName = resultData!['loginMosquee']['mosqueeName'];
 final mosqueId = resultData!['loginMosquee']['id'];
    return Column(
      children: [
  
        Expanded(
          child: PubListScreen(), 
        ),
      ],
    );
  }
}

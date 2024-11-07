import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/firsttime/imam_vetor.dart';
import 'package:masjidi/Screens/firsttime/masjid_infopage.dart';
import 'package:masjidi/Screens/firsttime/otp_page.dart';

class ImamInfopage extends StatelessWidget {
  final Map<String, dynamic>? resultData;

  ImamInfopage({super.key, required this.resultData});

  @override
  Widget build(BuildContext context) {
      Size screenSize = MediaQuery.of(context).size;
      final contact = resultData?['loginMosquee']['imam']?['employee']?['contact'] ?? 'لا يوجد إمام';


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
         automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
Container(
        
          height: 40,
          width: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: primaryColor),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white,size: 20,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
            Text(
              'معلومات التواصل مع الإمام',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height*0.1,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [const SizedBox(height: 20),
            
            const SizedBox(height: 20),
            InfoTile(
              label: 'رقم هاتف الإمام',
              icon: Icons.phone,
              text: contact,
              onTap: () {
              },
            ),
            SizedBox(height: screenSize.height*0.03),
            InfoTile(
              label: "تأكيد رقم هاتف الإمام",
              icon: Icons.phone,
              text: contact,
              onTap: () {

              },
            ),
            SizedBox(height: screenSize.height*0.05),
            ],),
          ),
           const Spacer(),
          Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: screenSize.height*0.3,
            width: double.infinity,
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "يرجي من الامام المسؤول ادخال رقم الهاتف الخاص به للتواصل مع المديرية",
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryColor,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(4, (index) {
                          var currentPage=1;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPage == index
                                  ? secondaryColor
                                  : secondaryColor.withOpacity(0.4),
                            ),
                          );
                        }),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                     Navigator.push(context,MaterialPageRoute<void>(
      builder: (BuildContext context) =>   ImamVetor(resultData: resultData,),
    ),);                 },
                        backgroundColor: secondaryColor,
                        child: const Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}
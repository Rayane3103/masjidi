import 'package:flutter/material.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/firsttime/add_employe.dart';

class ImamVetor extends StatelessWidget {
  final Map<String, dynamic>? resultData;

   ImamVetor({super.key, required this.resultData});

  @override
  Widget build(BuildContext context) {
      Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: 
         Column(
          children: [
            SizedBox(height: screenSize.height*0.16,),
            Image.asset('assets/images/imam.png'),
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
              "لاكمال عملية التسجيل علي تطبيق مسجدي يرجي من الامام المسؤول ملء قائمة موضفين المسجد",
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
                          var currentPage=2;
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
                            builder: (BuildContext context) => AddEmploye(resultData: resultData,),
                          ),);
                        },
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
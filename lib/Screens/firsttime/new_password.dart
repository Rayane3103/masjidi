import 'package:flutter/material.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/components/mymainwidget.dart';
import 'package:masjidi/components/mytextfield.dart';

class NewPasswordPage extends StatelessWidget {
    final Map<String, dynamic>? resultData;
    NewPasswordPage({super.key, required this.resultData});

 @override
  Widget build(BuildContext context) {
      Size screenSize = MediaQuery.of(context).size;
      final TextEditingController passwordController = TextEditingController();
      final TextEditingController confirmPasswordController= TextEditingController();
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
              'تجديد كلمة المرور',
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
      body: 
         Column(
          children: [
            SizedBox(height: screenSize.height*0.175,),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
  child: Mytextfield(icon: const Icon(Icons.lock), label: "كلمة المرور", obsecure: true, controller: passwordController),
),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 25),
            child: Mytextfield(icon: const Icon(Icons.lock), label: "تأكيد كلمة المرور", obsecure: true, controller: confirmPasswordController),
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
              "  لتاكيد الحساب علي تطبيق مسجدي يرجي من الامام المسؤول انشاء كلمة مرور",
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
                          var currentPage=3;
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
                        shape: const CircleBorder(),
                        onPressed: () {
                          Navigator.pushReplacement(context,MaterialPageRoute<void>(
                            builder: (BuildContext context) => MyMainWidget(resultData: resultData,),
                          ),);
                        },
                        backgroundColor: secondaryColor,
                        child: const Icon(Icons.done, color: Colors.white),
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
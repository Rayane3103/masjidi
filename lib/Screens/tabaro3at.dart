import 'package:flutter/material.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/add_tabaro3.dart';
import 'package:masjidi/Screens/alldetails_page.dart';
import 'package:masjidi/components/tabaro3atscreen.dart';
import 'package:intl/intl.dart';
class Tabaro3atPage extends StatelessWidget {
     final Map<String, dynamic>? resultData;
    final Map<String, dynamic>? talab;
    final String? projectId;
    final String day;
  const Tabaro3atPage({super.key, required this.resultData, required this.talab, required this.projectId, required this.day});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
DateTime getNextOrCurrentFriday() {
  DateTime now = DateTime.now();
  int weekday = now.weekday; 
  if (weekday == DateTime.friday) {
    return now; 
  } else {
    int daysUntilFriday = (DateTime.friday - weekday + 7) % 7;
    return now.add(Duration(days: daysUntilFriday));
  }
}
final mosqueName = resultData!['loginMosquee']['mosqueeName'];
 final mosqueId = resultData!['loginMosquee']['id'];
final fridayMosqueName = talab?['thisFridayProject']?['mosquee']?['mosqueeName'] ?? "لا يوجد تبرع هذا الأسبوع";
final String fridayDate = talab?['thisFridayProject']?['day'] ?? DateFormat('yyyy-MM-dd').format(getNextOrCurrentFriday());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, ),
          child: Column(
            children: [
             
              Container(
                
                width: screenSize.width*0.9,
                child: Stack(
                  
                  children:[
                  Image.asset('assets/images/machro3.png'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                    child: Align(
                      alignment: const Alignment(0.7, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                        Text(fridayMosqueName,style: TextStyle(color: secondaryColor,fontSize: 16,fontWeight: FontWeight.bold),),
                         
RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text: 'الجمعة: ', 
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold, 
        ),
      ),
      TextSpan(
        text: fridayDate,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 12,
        ),
      ),
    ],
  ),
),                      SizedBox(height: 10,),
                        // Container(
                        //   decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(30)),
                        //   width:80,height: 25 ,child: Center(child: 
                        //    Padding(
                        //      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //      child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //      children: [
                        //       Text('الموقع',style: TextStyle(color: Colors.white),),
                        //       Icon(Icons.location_pin,color: Colors.white,size: 20,)
                        //       ],),
                        //    ))),
                      ],),
                    ),
                  )
                  
                  ] ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(alignment: Alignment.topRight,child: Text("جميع التبرعات", style: TextStyle(fontSize: 18),textAlign: TextAlign.right,)),
                )
            ],
          ),
        ),
        Expanded(
          child: Tabaro3atScreen(mosqueeId: mosqueId, fridayId: projectId, day: day,), 
        ),
            ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/firsttime/imam_infopage.dart';

class MosqueInfoPage extends StatefulWidget {
final Map<String, dynamic>? resultData;
  MosqueInfoPage({Key? key, required this.resultData});
  @override
  State<MosqueInfoPage> createState() => _MosqueInfoPageState();
}

class _MosqueInfoPageState extends State<MosqueInfoPage> {
    int currentPage = 0; 

  @override
  Widget build(BuildContext context) {
                         final mosqueName = widget.resultData!['loginMosquee']['mosqueeName'];
                         final location = widget.resultData!['loginMosquee']['location'];
                           final imam = widget.resultData!['loginMosquee']['imam'];
    final imamName = imam != null && imam['employee'] != null
        ? imam['employee']['name']
        : 'No Imam Assigned';

    print("all data : ${widget.resultData}");
  
      Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  mosqueName,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
              'مسجد رئيسي',
              style: TextStyle(
                fontSize: 18,
                color: primaryColor,
              ),
            ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [const SizedBox(height: 20),
            
            const SizedBox(height: 20),
            InfoTile(
              label: "موقع المسجد",
              icon: Icons.location_on_outlined,
              text: location,
              onTap: () {
                // Handle location tap
              },
            ),
            SizedBox(height: screenSize.height*0.03),
            InfoTile(
              label: "الإمام المسؤول عن المسجد",
              icon: Icons.person_2_outlined,
              text: imamName,
              onTap: () {
              },
            ),
            SizedBox(height: screenSize.height*0.05),
            Center(
              child: SizedBox(
                width: screenSize.width,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('الإبلاغ عن خطأ في المعلومات',style: TextStyle(fontSize: 18),),
                ),
              ),
            ),],),
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يرجى من الامام المسؤول التأكد من معلومات الخاصة بالمسجد و الإبلاغ في حال وجود خطأ',
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
                      // Current page dots
                      Row(
                        children: List.generate(4, (index) {
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
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                   ImamInfopage(resultData: widget.resultData,),
                            ),
                          );
                        },
                        backgroundColor: secondaryColor,
                        child: const Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ],
                  ),
      )]))),
              ]),
                );
             
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;
  final VoidCallback onTap;

  const InfoTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.label
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
          Size screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, textAlign: TextAlign.right,style: TextStyle(color: primaryColor),),
        SizedBox(height: screenSize.height*0.015),

        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                                const SizedBox(width: 15),

                                Icon(icon, color: Colors.black87),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
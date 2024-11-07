import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/alldetails_page.dart';
import 'package:masjidi/Screens/homepage.dart';
import 'package:masjidi/Screens/madrassapage.dart';
import 'package:masjidi/Screens/school/new_school_page.dart';
import 'package:masjidi/Screens/tabaro3at.dart';
import 'package:masjidi/Screens/reciever1.dart';
import 'package:masjidi/components/maktabascreen.dart'; 

class MyMainWidget extends StatefulWidget {
  final Map<String, dynamic>? resultData;

  MyMainWidget({super.key, required this.resultData});

  @override
  State<MyMainWidget> createState() => _MyMainWidgetState();
}

class _MyMainWidgetState extends State<MyMainWidget> {
  int currentIndex = 0;
  DateTime? currentBackPressTime;
  bool canPopNow = false;
  late List<Widget> pages;
  String? loginMosqueId; 
  String? mosqueeName; 
   String? fridayMosqueId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loginMosqueId = widget.resultData!['loginMosquee']['id']; // Assuming this is where mosque ID is stored
    mosqueeName = widget.resultData!['loginMosquee']['mosqueeName']; // Assuming this is where mosque ID is stored
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchFridayMosque(); // Fetch mosque ID from thisFridayProject when dependencies change
  }

  Future<void> _fetchFridayMosque() async {
  final QueryOptions options = QueryOptions(
    fetchPolicy: FetchPolicy.noCache,
    document: gql(r'''
      query{thisFridayProject{
  day
  project{
    id
    DonnationRecived{
      mosqueeName
      day
      price
      mofaoudName
      mofaoudCard
    }
    
  }
  mosquee{
    mosqueeName
    location
    id
  }
}}
    '''),
  );

  GraphQLClient client = GraphQLProvider.of(context).value;
  final result = await client.query(options);

   if (!result.hasException && result.data != null) {
    final thisFridayProject = result.data?['thisFridayProject'];

    if (thisFridayProject != null && thisFridayProject['mosquee'] != null) {
      final projectDay = thisFridayProject['day'] ?? 'Unknown'; 
      final fridayMosqueId = thisFridayProject['project']?['id'];
      final fridayJama3Id = thisFridayProject['mosquee']?['id'];

      setState(() {
        this.fridayMosqueId = fridayMosqueId;
        print("This is Friday mosque ID: $fridayMosqueId");
        print("This is current mosque ID: $loginMosqueId");

        pages = [
          HomePage(resultData: widget.resultData),
          (loginMosqueId == fridayJama3Id)
              ? Reciever1(resultData: widget.resultData, projectId: fridayMosqueId!, projectDay: projectDay)
              : Tabaro3atPage(resultData: widget.resultData, talab: result.data, projectId: fridayMosqueId!, day: projectDay),
          MadrassaPage2(resultData: widget.resultData),
          MaktabaScreen(resultData: widget.resultData),
        ];

        isLoading = false; 
      });
    } else {
      print("No mosque found in thisFridayProject");
      setState(() {
        pages = [
          HomePage(resultData: widget.resultData),
          Tabaro3atPage(resultData: widget.resultData, talab: result.data, projectId: null, day: 'Unknown'),
          MadrassaPage2(resultData: widget.resultData),
          MaktabaScreen(resultData: widget.resultData),
        ];

        isLoading = false;
      });
    }
  } else {
    print("Error fetching thisFridayProject: ${result.exception.toString()}");
  }
}


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press again to exit')),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
                    automaticallyImplyLeading: false,

          title: InkWell(
                onTap: (){
            Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) =>  AllDetailsPage(mosqueeId: loginMosqueId.toString(),),
    ),
  );
          },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        mosqueeName!,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                           loginMosqueId!,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          Icon(Icons.copy_all,size: 22,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(top: screenSize.height * 0.04),
          child: isLoading
              ? const Center(child: CircularProgressIndicator()) 
              : pages[currentIndex], 
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: List.generate(icons.length, (index) {
            return BottomNavigationBarItem(
              icon: _buildIcon(index),
              label: tabNames[index],
            );
          }),
          currentIndex: currentIndex,
          selectedItemColor: primaryColor,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    return Container(
      decoration: BoxDecoration(
        color: currentIndex == index ? primaryColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        currentIndex == index ? selectedIcons[index] : icons[index],
        height: 24,
        width: 24,
        color: currentIndex != index ?primaryColor:Colors.white ,
      ),
    );
  }

  List<String> icons = [
    "assets/icons/homee.png",
    "assets/icons/tabaro3.png",
    "assets/icons/madrassa.png",
    "assets/icons/maktaba.png",
  ];

  List<String> selectedIcons = [
    "assets/icons/sel1.png",
    "assets/icons/sel2.png",
    "assets/icons/sel3.png",
    "assets/icons/sel4.png",
  ];

  List<String> tabNames = [
    "الرئيسية",
    "التبرعات",
    "المدرسة",
    "المكتبة",
  ];
}

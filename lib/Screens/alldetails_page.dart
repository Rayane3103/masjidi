import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Constants/lists.dart';
import 'package:masjidi/Screens/taps/activities.dart';
import 'package:masjidi/Screens/taps/employeeslist.dart';
import 'package:masjidi/Screens/taps/marafik.dart';
import 'package:masjidi/components/droppy.dart';
import 'package:masjidi/components/mytextfield.dart';
import 'package:masjidi/components/tapy_icon.dart';

class AllDetailsPage extends StatefulWidget {
  final String mosqueeId;
  const AllDetailsPage({super.key, required this.mosqueeId});

  @override
  State<AllDetailsPage> createState() => _AllDetailsPageState();
}

class _AllDetailsPageState extends State<AllDetailsPage> {
  int _selectedIndex = 0;
  String mosqueName = '';
  String imamName = '';
  String mosqueType = '';
   late List<Widget> _tabs; // Declare it as late

  @override
  void initState() {
    super.initState();
    
    // Initialize _tabs in initState, where widget.mosqueeId is accessible
    _tabs = [
      MarafikScreen(mosqueeId: widget.mosqueeId),
      Activities(mosqueeId: widget.mosqueeId,),
      EmployeeList(mosqueeId: widget.mosqueeId,),
    ];
  }
final String addActivityMutation = r'''
  mutation AddActivity($MosqueeId: ID!, $ImamId: ID!, $title: String!, $date: String!, $type: String!) {
    addActivity(MosqueeId: $MosqueeId, ImamId: $ImamId, title: $title, date: $date, type: $type) {
      ... on Error {
        message
      }
      ... on activity{
      id
      title
      type
    }
    }
  }
''';
  final String query = r'''
    query GetMosquee($id: ID!) {
      getMosquee(id: $id) {
        ... on Error {
          message
        }
        ... on Mosque {
          mosqueeName
          Willaya
          commune
          imam {
          id
            employee {
              id
              name
            }
          }
          type

        }
      }
    }
  ''';

  
@override
Widget build(BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
  return Query(
    options: QueryOptions(
      document: gql(query),
      variables: {'id': widget.mosqueeId},
      fetchPolicy: FetchPolicy.noCache,
    ),
    builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
      if (result.isLoading) {
        return Scaffold(backgroundColor: Colors.white,body: Center(child: CircularProgressIndicator(color: primaryColor)));
      }

       if (result.isLoading) {
          return Center(child: CircularProgressIndicator(color: primaryColor,));
        }

         if (result.hasException) {
            if (result.exception?.linkException != null) {
              // Handle network error
              return Scaffold(
                body: Center(
                  child: Text('خطأ في الاتصال بالشبكة. يرجى التحقق من اتصال الإنترنت الخاص بك.'),
                ),
              );
            } else if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
              // Handle GraphQL errors
              return Scaffold(
                body: Center(
                  child: Text('حدث خطأ في جلب البيانات من الخادم.'),
                ),
              );
              
            }
          }



      final mosqueData = result.data?['getMosquee'];
      final String willaya = mosqueData != null && mosqueData['Willaya'] != null ? mosqueData['Willaya'] : "غير محدد";
      final String commune = mosqueData != null && mosqueData['commune'] != null ? mosqueData['commune'] : "غير محدد";
      final String mosqueName = mosqueData != null && mosqueData['mosqueeName'] != null
          ? mosqueData['mosqueeName']
          : 'No data found';
      final String imamName = mosqueData != null && mosqueData['imam'] != null
          ? mosqueData['imam']['employee']['name'] ?? 'لا يوجد إمام'
          : 'لايوجد إمام';
      final String imamId = mosqueData != null && mosqueData['imam'] != null
          ? mosqueData['imam']['id'] ?? 'لا يوجد إمام'
          : 'لايوجد إمام';
      final String mosqueType = mosqueData != null && mosqueData['type'] != null
          ? MasjidType[mosqueData['type']]
          : 'No type found';




void _openAddActivityDialog(BuildContext context, RunMutation runMutation) {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String activityType = 'خطبة الجمعة'; 

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('إضافة نشاط'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'عنوان النشاط'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'تاريخ النشاط'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (pickedDate != null) {
                  dateController.text = pickedDate.toIso8601String().split('T')[0];
                }
              },
            ),
            DropdownButton<String>(
              value: activityType,
              items: ImamActivities.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  activityType = newValue!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              runMutation({
                'MosqueeId': widget.mosqueeId,
                'ImamId': imamId,
                'title': titleController.text,
                'date': dateController.text,
                'type': activityType,
              });
              Navigator.pop(context);
            },
            child: Text('إضافة'),
          ),
        ],
      );
    },
  );
}





      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Text(
                  'تفاصيل المسجد',
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
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: screenSize.height * 0.23,
                  width: screenSize.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          mosqueName,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child:  Text(
                            ' $commune , $willaya',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        RichText(
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                            text: 'الامام المسؤول: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: imamName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: '\n نوع المسجد: ',
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: mosqueType,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TappyIcon(
                    path: "assets/icons/tap3.png",
                    label: 'المرافق',
                    onTap: () {
                      _updateIndex(0);
                    },
                    isSelected: _selectedIndex == 0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                  TappyIcon(
                    path: "assets/icons/tap2.png",
                    label: 'النشاطات',
                    onTap: () {
                      _updateIndex(1);
                    },
                    isSelected: _selectedIndex == 1,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                  TappyIcon(
                    path: "assets/icons/tap1.png",
                    label: 'الموظفين',
                    onTap: () {
                      _updateIndex(2);
                    },
                    isSelected: _selectedIndex == 2,
                  ),
                ],
              ),
              _selectedIndex == 0
                  ? Padding(
                    padding: const EdgeInsets.only(right:40.0,top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("تقدم المشروع", textAlign: TextAlign.right),
                      ],
                    ),
                  )
                  : _selectedIndex == 1
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 40,left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Mutation(
  options: MutationOptions(
    document: gql(addActivityMutation),
    onCompleted: (dynamic resultData) {
      if (resultData != null && resultData['addActivity'] != null) {
        print('Activity added successfully');
      } else {
        print('Error adding activity');
      }
    },
    onError: (error) {
      print('the error of mutation: $error');
    },
  ),
  builder: (RunMutation runMutation, QueryResult? result) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        _openAddActivityDialog(context, runMutation); 
      },
    );
  },
),

// this is the mutation button of addActivity
                              Text('النشاطات'),
                            ],
                          ),
                        )
                      : Padding(
                        padding: const EdgeInsets.only(top: 10.0,right:40 ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(" الموظفين", textAlign: TextAlign.right),
                            ],
                          ),
                      ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: _tabs[_selectedIndex],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



}

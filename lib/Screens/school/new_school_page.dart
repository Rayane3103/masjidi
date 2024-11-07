import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Constants/lists.dart';

import 'package:masjidi/components/droppy.dart';
import 'package:masjidi/components/expandable_card.dart';


class MadrassaPage2 extends StatefulWidget {
  final Map<String, dynamic>? resultData;

  MadrassaPage2({super.key, required this.resultData});

  static const String getMosqueeWithSchoolQuery = r'''
    query GetMosquee($id: ID!) {
      getMosquee(id: $id) {
        ... on Error {
          message
        }
        ... on Mosque {
          employee {
            ... on Error { message }
            ... on Employee {
              id
              name
              contact
              role
              taklif
            }
          }
          School {
            ... on Error { message }
            ... on School {
           Etudient {
                ... on Error { message }
                ... on Etudient {
                  id
                  name
                  placeDeNaissance                
                  dateDeNaissance
                  hzb
                  }
              }
              id
              Name
              type
              employee {
                ... on Error { message }
                ... on Employee {
                  id
                  name
                  contact
                  dateOfstart
                  role
                  taklif
                }
              }
              TimeSlot {
                ... on Error { message }
                ... on TimeSlot {
                  day
                  hourOfStart
                  hourOfEnd
                }
              }
            }
          }
        }
      }
    }
  ''';

  @override
  State<MadrassaPage2> createState() => _MadrassaPage2State();
}

class _MadrassaPage2State extends State<MadrassaPage2> {
 
  TextEditingController madrassaType = TextEditingController();

  TextEditingController teacherName = TextEditingController();


String createSchoolMutation = r'''
  mutation addSchool($MosqueeId : ID , $Name : String , $type : String , $TimeSlot : [TimeSlotInput] , $EmployeeId : ID ) {
      addSchool(MosqueeId : $MosqueeId , Name : $Name ,  type : $type , TimeSlot : $TimeSlot , EmployeeId : $EmployeeId  ){
        ... on Mosque {
          School {
            ... on School{
            id
            
            }
            ... on Error{
              message
            }
          }
        }
        ... on Error{
          message
        }
      }
      
  }
''';

String getMosqueeQuery = r'''
  query getMosquee($id: ID!) {
    getMosquee(id: $id) {
       ...on Error{message}
  ... on Mosque{
    id
mosqueeName
Contact
employee{  ...on Error{message}
... on Employee{
            id
            name
            role
            taklif
            contact
            dateOfstart
          }}
School{  ...on Error{message}}

  }
}
    
  }
''';


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    final mosqueName = widget.resultData!['loginMosquee']['mosqueeName'];
    final mosqueId = widget.resultData!['loginMosquee']['id'];

    return Query(
      options: QueryOptions(
        document: gql(MadrassaPage2.getMosqueeWithSchoolQuery),
        variables: {'id': mosqueId},
        fetchPolicy: FetchPolicy.noCache
      ),
      builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        // if (refetch != null) {
        //   // Save the refetch function to call it later
        //   refetchQuery = refetch;
        // }
         if (result.isLoading) {
          return Center(child: CircularProgressIndicator(color: primaryColor,));
        }

         if (result.hasException) {
            if (result.exception?.linkException != null) {
              // Handle network error
              return Center(
                child: Text('خطأ في الاتصال بالشبكة. يرجى التحقق من اتصال الإنترنت الخاص بك.'),
              );
            } else if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
              // Handle GraphQL errors
              return Center(
                child: Text('حدث خطأ في جلب البيانات من الخادم.'),
              );
              
            }
          }

       
        final schoolData = result.data!['getMosquee']['School'];
        final mosqueData = result.data!['getMosquee'];
        final List employees = mosqueData['employee'] ?? [];
        final List teachers = employees.where((employee) => 
            employee['role'] == "مدرس القران" || employee['role'] == "مدرس القرآن" || employee['taklif'] == "مدرس القرآن" ||  employee['taklif'] == "مدرس القران"
        ).toList();

        final List<String> teacherNames = teachers.map((teacher) => teacher['name'] as String).toList();
        final List<Map<String, dynamic>> schoolDatas = List<Map<String, dynamic>>.from(schoolData);

        print("My schoool Dataaaa : $schoolDatas");
        if (schoolData == null || schoolData.isEmpty || schoolData[0]['message'] == "لا يحتوي هذا المسجد على مدرسة قراَنيـــة" || schoolData[0]['message'] == "لا يمكن العثور على مدرسة" ) {
          return Column(
            children: [
  //           
              SizedBox(height: screenSize.height * 0.08),
              Image.asset("assets/images/imam.png"),
              TextButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 500,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 5,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(height: 60),
                          Dropyy(hintText: 'اسم المدرس', dropItems: teacherNames, controller: teacherName),
                          Dropyy(hintText: 'نوع المدرسة', dropItems: MadrasaType, controller: madrassaType),
                          SizedBox(height: 60),
                          Container(
                            width: screenSize.width * 0.75,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                               final MyEmployee = employees.firstWhere(
  (employee) => employee['name'] == teacherName.text,
  orElse: () => null,
);
if (MyEmployee != null) {
  final MyEmployeeId = MyEmployee['id'];
  print("my employeeee id is : $MyEmployeeId");

  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height: 500,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: TimeSelectionWidget(
          schoolDatas: schoolDatas,
          mosqueId: mosqueId,
          mosqueName: mosqueName,
          teacherName: MyEmployeeId, 
          madrassaType: madrassaType.text,
          createSchoolMutation: createSchoolMutation,
        ),
      ),
    ),
  );
} else {
  print("Employee not found");
}

                              },
                              child: Text("التالي"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                child: Text(
                  "إضافة مدرسة",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        } else {
          return ExpandableCard(resultData: widget.resultData, schoolDatas: schoolDatas,refetch: refetch,);




               
             
         } });
        }
      }
   
 






class TimeSelectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>>? schoolDatas;
  final String mosqueId;
  final String mosqueName;
  final String teacherName;
  final String madrassaType;
  final String createSchoolMutation; // Add this line

  TimeSelectionWidget({
    required this.mosqueId,
    required this.mosqueName,
    required this.teacherName,
    required this.madrassaType,
    required this.createSchoolMutation,  this.schoolDatas, 
  });

  @override
  _TimeSelectionWidgetState createState() => _TimeSelectionWidgetState();
}

class _TimeSelectionWidgetState extends State<TimeSelectionWidget> {
  List<Map<String, dynamic>> timeSlots = [];

  String selectedDay = 'الأحد';
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<String> daysOfWeek = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت'
  ];

Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

  void addNewTimeSlot() {
    if (startTime != null && endTime != null) {
      setState(() {
        timeSlots.add({
          'day': switch (selectedDay) {
          'السبت' => 1,
          'الأحد' => 2,
          'الإثنين' => 3,
          'الثلاثاء' => 4,
          'الأربعاء' => 5,
          'الخميس' => 6,
          'الجمعة' => 7,
          String() => throw UnimplementedError(),
        },
          'hourOfStart': startTime!.format(context),
          'hourOfEnd': endTime!.format(context),
        });
        // Reset the values after adding the time slot
        selectedDay = 'الأحد';
        startTime = null;
        endTime = null;
      });
    } else {
      // Show a warning if time slots are not complete
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار وقت البداية و النهاية')),
      );
    }
  }
void _createSchool() async {
  try {
    final client = GraphQLProvider.of(context).value;
    
    String formatTime(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    final MutationOptions options = MutationOptions(
      document: gql(widget.createSchoolMutation),
      variables: {
        'MosqueeId': widget.mosqueId,
        'Name': widget.mosqueName,
        'EmployeeId': widget.teacherName,
        'type': widget.madrassaType,
        'TimeSlot': 
        timeSlots
      },
      onError: (error) {
        print('Mutation error: $error');
      },
      onCompleted: (dynamic schoolResults) {
        print('Mutation result: $schoolResults');
        Navigator.pop(context);
      },
      
    );

    client.mutate(options);
  } catch (e) {
    print(e);
  }
}
  void removeTimeSlot(int index) {
    setState(() {
      timeSlots.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: timeSlots.isNotEmpty
                  ? ListView.builder(
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = timeSlots[index];
                       String myDay = '';
switch (slot['day']) {
  case 1:
    myDay = 'السبت';
    break;
  case 2:
    myDay = 'الأحد';
    break;
  case 3:
    myDay = 'الإثنين';
    break;
  case 4:
    myDay = 'الثلاثاء';
    break;
  case 5:
    myDay = 'الأربعاء';
    break;
  case 6:
    myDay = 'الخميس';
    break;
  case 7:
    myDay = 'الجمعة';
    break;
  default:
    myDay = 'غير معروف'; 
}

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                              IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeTimeSlot(index),
                            ),
                              Text('${myDay}: ${slot['hourOfStart']} - ${slot['hourOfEnd']}'),
                             
                             ],
                          ),
                        );
                      },
                    )
                  : Center(child: Text('لا يوجد حصص حتى الآن')),
            ),

            Divider(),

            Text('حصة جديدة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xFF06433D))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap:addNewTimeSlot ,
                  child: Container(
decoration: BoxDecoration(
    color:  Color(0xFF30FF4F), 
    shape: BoxShape.circle, 
  ),                    height: 40,
                    width: 40,
                    child: Icon(Icons.done),
                  ),
                ),
                                SizedBox(width: 5),

                InkWell(
                  onTap: () => _pickTime(context, true),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      
                      color: Color(0xFFD9D9D9),borderRadius: BorderRadius.circular(20)),
                    width: MediaQuery.sizeOf(context).width*0.225,
                    child: Center(child: Text(startTime != null ? startTime!.format(context) : 'بداية الحصة',style: TextStyle(color: Color(0xFF06433D)),))),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () => _pickTime(context, false),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      
                      color: Color(0xFFD9D9D9),borderRadius: BorderRadius.circular(20)),
                    width: MediaQuery.sizeOf(context).width*0.225,
                    child: Center(child: Text(endTime != null ? endTime!.format(context) : 'نهاية الحصة',style: TextStyle(color:Color(0xFF06433D)),))),
                ),
                                SizedBox(width: 5),

                Container(
                  width: MediaQuery.sizeOf(context).width*0.225,
                  child: Center(
                    child: DropdownButton<String>(
                      value: selectedDay,
                      items: daysOfWeek.map((day) {
                        return DropdownMenuItem(
                          child: Text(day),
                          value: day,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDay = value!;
                        });
                      },
                    ),
                  ),
                ),
                
              ],
            ),

            SizedBox(height: 20),

            
            ElevatedButton(
              onPressed: _createSchool,
              child: Text('تأكيد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      
    );



}
}
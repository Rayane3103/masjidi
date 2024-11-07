import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Constants/lists.dart';
import 'package:masjidi/Screens/add_etudiant.dart';
import 'package:masjidi/Screens/school/new_school_page.dart';
import 'package:masjidi/components/droppy.dart';
import 'package:masjidi/components/madrassa_screen.dart';

// ignore: must_be_immutable
class ExpandableCard extends StatefulWidget {
 final List<Map<String, dynamic>> schoolDatas;
      final Map<String, dynamic>? resultData;
      final Function? refetch;
TextEditingController madrassaType = TextEditingController();
  TextEditingController teacherName = TextEditingController();

ExpandableCard({super.key, required this.resultData,  required this.schoolDatas, this.refetch});
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
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;
  int _selectedSchoolIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
        
 final selectedSchool = widget.schoolDatas[_selectedSchoolIndex];
    final teacherName = selectedSchool['employee'] != null ? selectedSchool['employee']['name'] : "Unknown";
    final timeSlots = selectedSchool['TimeSlot'] ?? [];
            print("the techers nammmees are: $teacherName");
            print("timeslots arrre fetched like this: $timeSlots");
                   final Students = selectedSchool['Etudient'];

   
        return Padding(
          padding: const EdgeInsets.only(bottom:10.0),
          child: Column(
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1, 5),
                          blurRadius: BorderSide.strokeAlignOutside,
                          blurStyle: BlurStyle.normal
                        )],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: _isExpanded ? 250 : 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: primaryColor,
                                          onPressed: ()  {
                                            
                                            showModalBottomSheet(context: context, 
                                            builder: (context) =>Container(
                                              height: 500,
                                              width: double.infinity,
                                              child: EditTimeSlots(timeSlots:timeSlots
                                              ),
                                            )
                                            );
                                            
                                            },
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final mosqueId = widget.resultData!['loginMosquee']['id'];
                                            final client = GraphQLProvider.of(context).value;
              
                                            final QueryResult result = await client.query(
                                              QueryOptions(
                                                document: gql(widget.getMosqueeQuery),
                                                variables: {'id': mosqueId},
                                              ),
                                            );
              
                                            if (result.hasException) {
                                              print(result.exception.toString());
                                              return;
                                            }
              
                                            final mosqueData = result.data!['getMosquee'];
                                            final List employees = mosqueData['employee'] ?? [];
                                            final List teachers = employees
                                                .where((employee) =>
                                                    employee['role'] == "مدرس القران" ||
                                                    employee['role'] == "مدرس القرآن")
                                                .toList();
              
                                            final List<String> teacherNames =
                                                teachers.map((teacher) => teacher['name'] as String).toList();
              
                                            // Show bottom sheet with teacher names
                                            showModalBottomSheet(
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
                                                      Dropyy(
                                                          hintText: 'اسم المدرس',
                                                          dropItems: teacherNames,
                                                          controller: widget.teacherName),
                                                      Dropyy(
                                                          hintText: 'نوع المدرسة',
                                                          dropItems: MadrasaType,
                                                          controller: widget.madrassaType),
                                                      SizedBox(height: 60),
                                                      Container(
                                                        width: screenSize.width * 0.75,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            final MyEmployee = employees.firstWhere(
                                                              (employee) =>
                                                                  employee['name'] == widget.teacherName.text,
                                                              orElse: () => null,
                                                            );
              
                                                            if (MyEmployee != null) {
                                                              final MyEmployeeId = MyEmployee['id'];
                                                              print("Employee ID: $MyEmployeeId");
              
                                                              showModalBottomSheet(
                                                                context: context,
                                                                builder: (context) => Container(
                                                                  height: 500,
                                                                  width: double.infinity,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        horizontal: 20.0, vertical: 10),
                                                                    child: TimeSelectionWidget(
                                                                      mosqueId: mosqueId,
                                                                      mosqueName: mosqueData['mosqueeName'],
                                                                      teacherName: MyEmployeeId,
                                                                      madrassaType: widget.madrassaType.text,
                                                                      createSchoolMutation: widget.createSchoolMutation,
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
                                            );
                                          },
                                          icon: Icon(Icons.add_circle_rounded, color: primaryColor),
                                        ),
                                      ],
                                    ),
                                  
                            
                              Text(
                                teacherName , 
                                style:  TextStyle(
                                  fontSize: 20,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                         Row(
                          textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width*0.75,
                            height: 35,
                            child: ListView.builder(
                              reverse: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.schoolDatas.length,
                              itemBuilder: (context, index) {
                                final schoolType = widget.schoolDatas[index]['type'];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedSchoolIndex = index;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: _selectedSchoolIndex == index ? secondaryColor : const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        schoolType,
                                        style: TextStyle(
                                          color: _selectedSchoolIndex == index ? Colors.white : secondaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height*0.0225,),
                          if (_isExpanded)
                             Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.calendar_today, color: secondaryColor),
                                        SizedBox(width: 4),
                                        Text(
                                          'مواعيد الحصص',
                                          style: TextStyle(color: secondaryColor, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                     TimeSlotDisplay(timeSlots: timeSlots)
              
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: _isExpanded ? -30 : -20,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 4),
                              color: secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.0225,),
              Expanded(
                    child: MadrassaScreen(students: Students,),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: MediaQuery.sizeOf(context).height*0.07,
                      width: MediaQuery.sizeOf(context).width*0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        final newStudent = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AddEtudiant(schoolId: selectedSchool['id'].toString(), refetchQuery: widget.refetch,),
              ),
            );
            if(newStudent!=null){
              setState(() {
                Students.add(newStudent);
              });
            }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        "إضافة طالب",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
            ],
          ),
        );
      
  }
}

class TimeSlotDisplay extends StatelessWidget {
  final List<dynamic> timeSlots;

  TimeSlotDisplay({required this.timeSlots});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          _buildTimeSlotText(),
          textAlign: TextAlign.right,
          style: TextStyle(color: secondaryColor, fontSize: 14),
        ),
      ],
    );
  }

  String _buildTimeSlotText() {
    Map<int, String> dayNames = {
      0: 'الأحد',
      1: 'الإثنين',
      2: 'الثلاثاء',
      3: 'الأربعاء',
      4: 'الخميس',
      5: 'الجمعة',
      6: 'السبت',
    };

    String result = "";
    for (var slot in timeSlots) {
      int day = slot['day'] ?? 0;
      String start = slot['hourOfStart'] ?? '';
      String end = slot['hourOfEnd'] ?? '';
      result += '${dayNames[day]}: $start - $end\n';
    }
    return result.trim(); // Removes the trailing new line
  }
}



class EditTimeSlots extends StatefulWidget {
final List< dynamic> timeSlots;
  EditTimeSlots({super.key, required this.timeSlots});

  @override
  State<EditTimeSlots> createState() => _EditTimeSlotsState();
}

class _EditTimeSlotsState extends State<EditTimeSlots> {
 

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
        widget.timeSlots.add({
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
        selectedDay = 'الأحد';
        startTime = null;
        endTime = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار وقت البداية و النهاية')),
      );
    }
  }

// void _updateSchool() async {
//   try {
//     final client = GraphQLProvider.of(context).value;
    
//     String formatTime(TimeOfDay time) {
//       final hour = time.hour.toString().padLeft(2, '0');
//       final minute = time.minute.toString().padLeft(2, '0');
//       return '$hour:$minute';
//     }

//     final MutationOptions options = MutationOptions(
//       document: gql(widget.updateSchoolMutation),
//       variables: {
        
//         'TimeSlot': 
//         timeSlots
//       },
//       onError: (error) {
//         print('Mutation error: $error');
//       },
//       onCompleted: (dynamic schoolResults) {
//         print('Mutation result: $schoolResults');
//         Navigator.pop(context);
//       },
      
//     );

//     client.mutate(options);
//   } catch (e) {
//     print(e);
//   }
// }

  void removeTimeSlot(int index) {
    setState(() {
      widget.timeSlots.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: widget.timeSlots.isNotEmpty
                  ? ListView.builder(
                      itemCount: widget.timeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = widget.timeSlots[index];
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
              onPressed:(){
                //  _updateSchool
                Navigator.pop(context);
                
                 },
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
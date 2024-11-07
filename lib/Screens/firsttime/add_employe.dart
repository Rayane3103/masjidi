import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Constants/lists.dart';
import 'package:masjidi/Screens/firsttime/new_password.dart';
import 'package:masjidi/components/droppy.dart';
import 'package:masjidi/components/mytextfield.dart';
import 'package:masjidi/models/employee_model.dart';

class AddEmploye extends StatefulWidget {
  final Map<String, dynamic>? resultData;

  AddEmploye({super.key, required this.resultData});

  @override
  State<AddEmploye> createState() => _AddEmployeState();
}

class _AddEmployeState extends State<AddEmploye> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController currentrole = TextEditingController();
  final TextEditingController currenttaklif = TextEditingController();
  final TextEditingController contact = TextEditingController();

  List<Employee> employees = [];
  bool _isLoading = false;

  void _addEmployee() {
  setState(() {
    employees.add(Employee(
      name: nameController.text,
      role: currentrole.text,
      taklif: currenttaklif.text,
      contact: contact.text,
      dateOfstart: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(' بنجاح ${nameController.text} تمت إضافة'),
        backgroundColor: primaryColor,
      ),
    );

    // Clear all controllers
    nameController.clear();
    currentrole.clear();
    currenttaklif.clear();
    contact.clear();
  });
}


  void _showConfirmationDialog(RunMutation runMutation) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text(
          'تأكيد الإضافة',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'سيتم إضافة الموظفين الى مسجدك. في حالة إضافة موظف آخر يرجى الإلغاء والضغط على إضافة موظف آخر',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (employees.isEmpty) {
                // If no employees were added, navigate to the next page without mutation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewPasswordPage(resultData: widget.resultData),
                  ),
                );
              } else {
                setState(() {
                  _isLoading = true;
                });

                // Proceed with the mutation
                runMutation({
                  'id': widget.resultData!['loginMosquee']['id'], 
                  'employees': employees.map((e) => e.toMap()).toList(),
                });

                Navigator.of(context).pop(); // Close the dialog
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: const Text(
              'تأكيد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
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
              'إضافة الموظفين',
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Mutation(
          options: MutationOptions(
            document: gql(r'''
              mutation AddEmployee($id: ID!, $employees: [EmployeeInput]) {
  addEmployee(Mosqueeid: $id, employees: $employees) {
    __typename
    ... on Error { message }
    ... on Mosque {
      employee {
        __typename
        ... on Error { message }
        ... on Employee { name }
      }
    }
  }
}

            '''),
            onCompleted: (resultData) {
  setState(() {
    _isLoading = false;
  });

  if (resultData != null) {
    print('Mutation result: $resultData'); // Detailed log

    if (resultData['addEmployee'] != null) {
      final response = resultData['addEmployee'];

      if (response['__typename'] == 'Error') {
        print('Error: ${response['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      } else if (response['__typename'] == 'Mosque') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPasswordPage(resultData: widget.resultData),
          ),
        );
      } else {
        print('Unexpected result structure: $resultData');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected response from server.')),
        );
      }
    } else {
      print('addEmployee field is null in resultData.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data returned from mutation.')),
      );
    }
  } else {
    print('Mutation completed but resultData is null.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No data returned from mutation.')),
    );
  }
},


            onError: (error) {
  setState(() {
    _isLoading = false; 
  });
  print('GraphQL Error: ${error.toString()}');

  String errorMessage = 'حدث خطــأ أثنــاء جلــب البيانــات. حاول مرة أخرى.';
  if (error?.graphqlErrors.isNotEmpty ?? false) {
    errorMessage = error?.graphqlErrors.map((e) => e.message).join(', ') ?? errorMessage;
  }
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(errorMessage)),
  );
}

          ),
          builder: (RunMutation runMutation, QueryResult? result) {
            return Stack(
              children: [
                ListView(
                  children: [
                    Mytextfield(
                      icon: const Icon(Icons.person),
                      label: "اسم الموظف",
                      obsecure: false,
                      controller: nameController,
                    ),
                    
                    Dropyy(hintText:  "الرتبة الحالية", dropItems: EmployeType, controller: currentrole),
                    Dropyy(hintText: "الوظيف الحالية", dropItems: EmployeType, controller: currenttaklif),
                    Mytextfield(
                      icon: const Icon(Icons.phone),
                      label: "رقم الهاتف",
                      obsecure: false,
                      controller: contact,
                    ),
                    SizedBox(height: 75),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _addEmployee,
                        child: const Text("إضافة موظف آخر", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: primaryColor, width: 1),
                          foregroundColor: primaryColor,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          
                          await _addEmployee;
                          
                          _showConfirmationDialog(runMutation);}, 
                        child: const Text("تأكيد", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

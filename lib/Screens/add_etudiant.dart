import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Constants/lists.dart';
import 'package:masjidi/components/droppy.dart';
import 'package:masjidi/components/mytextfield.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:intl/intl.dart'; 

class AddEtudiant extends StatefulWidget {
  final String schoolId;
  final Function? refetchQuery;

  const AddEtudiant({super.key, required this.schoolId, required this.refetchQuery, });

  @override
  _AddEtudiantState createState() => _AddEtudiantState();
}

class _AddEtudiantState extends State<AddEtudiant> {
  final TextEditingController talebName = TextEditingController();
  final TextEditingController dateDeNaissance = TextEditingController();
  final TextEditingController willaya = TextEditingController();
  final TextEditingController daira = TextEditingController();
  final TextEditingController hzb = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
  final DateTime currentDate = DateTime.now();
  DateTime? initialDate;

  try {
    initialDate = dateDeNaissance.text.isNotEmpty
        ?  DateTime.parse(dateDeNaissance.text)
        : currentDate;
  } catch (e) {
    initialDate = currentDate;
  }

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate!,
    firstDate: DateTime(1900),
    lastDate: currentDate,
  );

  if (pickedDate != null) {
    setState(() {
      dateDeNaissance.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      print("Selected date: ${dateDeNaissance.text}");
    });
  }
}


  @override
  Widget build(BuildContext context) {
    print("school id is : ${widget.schoolId}");

    const String addEtudiantMutation = """
    mutation AddEtudient(\$SchoolId: ID!, \$input: EtudientInput!) {
      addEtudient(SchoolId: \$SchoolId, input: \$input) {
        ... on Error{message}
    ... on School{id
    		Etudient{
          ... on Etudient{
            name
                        placeDeNaissance

            dateDeNaissance
            hzb
            
          }
        }
    }
      }
    }
    """;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'إضافة طالب جديد',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image.asset("assets/images/talib.png", height: 200),
          Mytextfield(label: "اسم الطالب", obsecure: false, controller: talebName),
          Dropyy(hintText: 'الولاية', dropItems: ["سيدي بلعباس"], controller: willaya),
          Dropyy(hintText: 'الدائرة', dropItems: dairas, controller: daira),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: Mytextfield(
                label: "تاريخ الميلاد",
                obsecure: false,
                controller: dateDeNaissance,
              ),
            ),
          ),
          Mytextfield(label: "الحزب", obsecure: false, controller: hzb),
          SizedBox(height: MediaQuery.sizeOf(context).height*0.025,),
          Mutation(
            options: MutationOptions(
              document: gql(addEtudiantMutation),
              onCompleted: (dynamic resultData) {
                print("Mutation completed: $resultData");
          if (resultData != null && resultData['addEtudient'] != null) {
        final newStudent = {
          'name': talebName.text,
          'placeDeNaissance': willaya.text + " - " + daira.text,
          'dateDeNaissance': dateDeNaissance.text,
          'hzb': hzb.text,
        };

        Navigator.pop(context, newStudent);  
      }
    },
              onError: (error) => print("the error is : $error"),
            ),
            builder: (RunMutation runMutation, QueryResult? result) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: primaryColor),
                onPressed: () {
  if (talebName.text.isEmpty ||
      willaya.text.isEmpty ||
      daira.text.isEmpty ||
      dateDeNaissance.text.isEmpty ||
      hzb.text.isEmpty) {
    print("Please fill in all fields.");
    return; 
  }

  print("Passing data to mutation:");
  print({
    'SchoolId': widget.schoolId,
    'input': {
      'name': talebName.text,
      'placeDeNaissance': willaya.text + " - " + daira.text,
      'dateDeNaissance': dateDeNaissance.text,
      'hzb': hzb.text,
    },
  });

  runMutation({
    'SchoolId': widget.schoolId,
    'input': {
      'name': talebName.text,
      'placeDeNaissance': willaya.text + " - " + daira.text,
      'dateDeNaissance': dateDeNaissance.text,
      'hzb': hzb.text,
    },
  });
},

                child: const Text('أضف الطالب'),
              );
            },
          ),
        ],
      ),
    );
  }
}

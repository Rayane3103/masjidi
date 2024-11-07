import 'dart:convert';  
import 'dart:io';  
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';  
import 'package:intl/intl.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/components/mytextfield.dart';  

class AddDonationPage extends StatefulWidget {
  final mosqueId;
  final projectId;
  final projectDay;
  const AddDonationPage({super.key, required this.mosqueId, required this.projectId, this.projectDay});
  @override
  _AddDonationPageState createState() => _AddDonationPageState();
}

class _AddDonationPageState extends State<AddDonationPage> {
  TextEditingController nameController = TextEditingController();
  File? _image;
  String? _base64Image;
  final picker = ImagePicker();

  final String setDonationMutation = """
  mutation SetDonnation(\$mosqueeId: ID!, \$projectId: ID!, \$mofaoudName: String!, \$mofaoudCard: String!, \$day: String!) {
    SetDonnation(MosqueeId: \$mosqueeId, ProjectId: \$projectId, mofaoudName: \$mofaoudName, mofaoudCard: \$mofaoudCard, day: \$day) {
      ... on Error { 
        message 
      }
      ... on Mosque { 
        id 
        mosqueeName 
      }
    }
  }
""";
Future<void> _pickImage() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path);
    });
    final bytes = await _image!.readAsBytes();  
    setState(() {
      _base64Image = base64Encode(bytes); 
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة تبرع جديد', style: TextStyle(color: primaryColor)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Mytextfield(
              label: 'اسم المفوض',
              obsecure: false,
              controller: nameController,
              icon: Icon(Icons.person, color: primaryColor),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.add_a_photo),
                  label: Text('تحميل وثيقة'),
                ),
                Icon(Icons.picture_as_pdf),  
              ],
            ),
            SizedBox(height: 16),
            _image != null
                ? Image.file(_image!, height: 150)
                : Image.asset('assets/images/id.png', height: 150), 
            SizedBox(height: 32),
            Mutation(
              options: MutationOptions(
                document: gql(setDonationMutation),
                onError: (error) {
                  print("an error occured to the mutation: $error");
                },
                onCompleted: (dynamic resultData) {
  print("Mutation completed: $resultData");
  if (resultData != null) {
    print(resultData['SetDonnation']['message']);
  };
  Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('تمت اضافة التبرع بنجاح'),
                      ));
}

              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return ElevatedButton(
                  onPressed: () {
                    if (//_base64Image != null && 
                    nameController.text.isNotEmpty) {
                      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
print(today);
runMutation({
  "mosqueeId": widget.mosqueId,
  "projectId": widget.projectId,
  "mofaoudName": nameController.text,
  "mofaoudCard": _base64Image ?? 'لا يوجد بطاقة',
  "day": widget.projectDay
});


                    } else {
                      // Show error message if fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('الرجاء ملأ المعلومات   '),
                      ));
                    }
                  },
                  child: Text('التالي'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

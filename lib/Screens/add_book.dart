import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Constants/lists.dart';
import 'package:masjidi/components/droppy.dart';
import 'package:masjidi/components/mytextfield.dart';

// Define the addBook mutation
const String addBookMutation = """
  mutation addBook(\$input: bookInput!) {
    addBook(input: \$input) {
      ... on book {
        bookName
      }
      ... on Error {
        message
      }
    }
  }
""";

class AddBook extends StatefulWidget {
  AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {

  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController numberOfPartController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController creatorController = TextEditingController();
  final TextEditingController detecteurController = TextEditingController();
  final TextEditingController DarNacherController = TextEditingController();
  final TextEditingController DateOfPublierController = TextEditingController();
  final TextEditingController CountryController = TextEditingController();
  final TextEditingController interditController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    DateTime? initialDate;

    try {
      initialDate = DateOfPublierController.text.isNotEmpty
          ? DateTime.parse(DateOfPublierController.text)
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
        DateOfPublierController.text =
            pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
        Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'اضافة كتاب',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Mytextfield(
                      label: ':اسم الكتاب',
                      obsecure: false,
                      controller: bookNameController),
                  Mytextfield(
                      label: 'عدد المجلدات',
                      obsecure: false,
                      controller: numberOfPartController),
                  Dropyy(
                      hintText: 'قسم الكتاب',
                      dropItems: BookType,
                      controller: classController),
                  Mytextfield(
                      label: 'المؤلف', obsecure: false, controller: creatorController),
                  Mytextfield(
                      label: 'المحقق', obsecure: false, controller: detecteurController),
                  Mytextfield(
                      label: 'دار النشر', obsecure: false, controller: DarNacherController),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: Mytextfield(
                          label: "تاريخ النشر",
                          obsecure: false,
                          controller: DateOfPublierController),
                    ),
                  ),
                  Dropyy(
                      hintText: 'البلد',
                      dropItems: arabicCountries,
                      controller: CountryController),
                ],
              ),
            ),
            Mutation(
              options: MutationOptions(
                document: gql(addBookMutation),
                onCompleted: (dynamic resultData) {
                  print(resultData);
                  if (resultData != null || resultData['addBook'] != null) {
                    final book = resultData['addBook'];
                    if (book['bookName'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book added: ${book['bookName']}')),
                      );
                    } else if (book['message'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${book['message']}')),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${error.toString()}')),
                  );
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: screenSize.height * 0.065,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final input = {
                          'bookName': bookNameController.text,
                          'numberOfPart': int.tryParse(numberOfPartController.text),
                          'Class': classController.text,
                          'Creator': creatorController.text,
                          'detecteur': detecteurController.text,
                          'DarNacher': DarNacherController.text,
                          'DateOfPublier': DateOfPublierController.text,
                          'Country': CountryController.text,
                          'interdit': false,
                        };
                    
                        runMutation({'input': input});
                      },
                      child: Text('أضف الكتاب'),
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor,foregroundColor: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

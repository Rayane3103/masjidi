import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart'; // Make sure to import the graphql_flutter package
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/components/mytextfield.dart';

// ignore: must_be_immutable
class MadrassaScreen extends StatelessWidget {
  final List<dynamic>? students;

  MadrassaScreen({super.key, required this.students});

  String updateHzb = r'''
    mutation updateEtudient($ID: ID!, $name: String!, $placeDeNaissance: String!, $dateDeNaissance: String!, $hzb: String!) {
      updateEtudient(EtudientId: $ID, input: { 
        name: $name, 
        placeDeNaissance: $placeDeNaissance, 
        dateDeNaissance: $dateDeNaissance, 
        hzb: $hzb 
      }) {
        ... on Error {
          message
        }
        ... on Etudient {
          id
          name
          placeDeNaissance
          dateDeNaissance
          hzb
        }
      }
    }
  ''';

  @override
  Widget build(BuildContext context) {
    TextEditingController hzbController = TextEditingController();
    print("my students are: $students");

    if (students != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.builder(
          itemCount: students!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                showModalBottomSheet(
  context: context,
  isScrollControlled: true, // Allow the bottom sheet to resize when the keyboard appears
  builder: (context) => Container(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.8, // Limit height to 80% of the screen
    ),
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: SingleChildScrollView( // Allow scrolling if the keyboard overlaps
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(':الاسم واللقب'),
                Icon(Icons.person, color: secondaryColor),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text((students![index]['name'] != null) ? students![index]['name'] : 'No Name'),
            ),
            // Name
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(' :تاريخ الميلاد'),
                Icon(Icons.date_range, color: secondaryColor), 
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text((students![index]['dateDeNaissance'] != null) ? students![index]['dateDeNaissance'] : 'No Date'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(':مكان الميلاد'),
                Icon(Icons.location_on, color: secondaryColor), 
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text((students![index]['placeDeNaissance'] != null) ? students![index]['placeDeNaissance'] : 'No Name'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(':الحزب'),
                Icon(Icons.people, color: secondaryColor), 
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text((students![index]['hzb'] != null) ? students![index]['hzb'] : 'No Name'),
            ),
            Mytextfield(
              label: 'تحديث الحزب',
              obsecure: false,
              controller: hzbController,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final GraphQLClient client = GraphQLProvider.of(context).value; 

                final result = await client.mutate(
                  MutationOptions(
                    document: gql(updateHzb),
                    variables: {
                      'ID': students![index]['id'], 
                      'name': students![index]['name'],
                      'placeDeNaissance': students![index]['placeDeNaissance'],
                      'dateDeNaissance': students![index]['dateDeNaissance'],
                      'hzb': hzbController.text, 
                    },
                    
                  ),
                );

                if (result.hasException) {
                  print('Error updating student: ${result.exception.toString()}');
                } else {
                  print('Student updated successfully: ${result.data}');
                }
                
                Navigator.pop(context); 
              },
              child: Text(
                'تحديث',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: Center(
                        child: Image.asset('assets/icons/taleb.png'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          (students![index]['name'] != null) ? students![index]['name'] : 'No Name',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          (students![index]['dateDeNaissance'] != null) ? students![index]['dateDeNaissance'] : 'No Date',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Center(child: Text("لا يوجد طلبة"));
    }
  }
}

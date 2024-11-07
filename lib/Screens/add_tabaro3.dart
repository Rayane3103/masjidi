import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart'; 
import 'package:intl/intl.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/add_mofawad.dart';
import 'package:masjidi/Screens/tabaro3at.dart';
import 'package:masjidi/components/mytextfield.dart';

class AddTabaro3 extends StatelessWidget {
  final String projectId;
  final String mosqueeId;
  final String donnationId;
  final String day;
  final Function? myRefetch;
  AddTabaro3({super.key, required this.projectId, required this.mosqueeId, required this.donnationId, required this.day, this.myRefetch});

  TextEditingController sommeController = TextEditingController();
  TextEditingController lettreController = TextEditingController();

  
  final String setDonationMutation = """
    mutation addPriceDonnation(
      \$mosqueeId: ID!,
      \$projectId: ID!,
      \$price:Int!,
      \$priceWithArabic: String!,
      \$id: ID!
    ) {
      addPriceDonnation(
        MosqueeId: \$mosqueeId,
        ProjectId: \$projectId,
        price: \$price,
        priceWithArabic: \$priceWithArabic,
        
        DonnationId: \$id
      ) {
        ... on Error{message}
  ... on project{
    id
    DonnationRecived{
      price
      mofaoudName
    }
  }
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'إضافة تبرع جديد',
              style: TextStyle(
                color: primaryColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Image.asset("assets/images/zakat.png"),
            Mytextfield(
              label: "المبلغ المجموع بالارقام",
              obsecure: false,
              controller: sommeController,
            ),
            const SizedBox(height: 20),
            Mytextfield(
              label: "المبلغ المجموع بالحروف",
              obsecure: false,
              controller: lettreController,
            ),
            const SizedBox(height: 20),
            Mutation(
              options: MutationOptions(
                document: gql(setDonationMutation),
                onCompleted: (dynamic resultData) {
                  if (resultData != null) {
                    print("Donation added: $resultData");
                     final int price = int.parse(sommeController.text);  // Safe to parse now

                    final newTabaro3 = {
                      'mosqueeId': mosqueeId,
                      'projectId': projectId,
                      'price': price,
                      'priceWithArabic': lettreController.text,
                      'id': donnationId, 
                    };
                                      Navigator.pop(context,newTabaro3);

                  }

                },
                onError: ( error) {
                  print("Error occurred: ${error}");
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return ElevatedButton(
                  onPressed: () {
 final int price = int.parse(sommeController.text);  // Safe to parse now
  print(price);
                    runMutation({
                      'mosqueeId': mosqueeId,
                      'projectId': projectId,
                      'price': price,
                      'priceWithArabic': lettreController.text,
                      'id': donnationId, 
                    });

                  },
                  child: const Text("تأكيد"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
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

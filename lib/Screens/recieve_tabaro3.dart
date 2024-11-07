import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart'; 
import 'package:intl/intl.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/components/mytextfield.dart';

class RecieveTabaro3 extends StatelessWidget {
  final String projectId;
  final String mosqueeId;
  final String donnationId;
  final String day;

  RecieveTabaro3({
    super.key,
    required this.projectId,
    required this.mosqueeId,
    required this.donnationId,
    required this.day,
  });

  TextEditingController sommeController = TextEditingController();
  TextEditingController lettreController = TextEditingController();

  String recieveDonation = """
    mutation ReciveDonnation(\$DonnationId: ID!, \$ProjectId: ID!, \$MosqueeId: ID!, \$price: Int!) {
      ReciveDonnation(DonnationId: \$DonnationId, ProjectId: \$ProjectId, MosqueeId: \$MosqueeId, price: \$price) {
        ... on project {
          id
          DonnationRecived {
            id
            mosqueeName
            priceRecived
            price
            mofaoudName
            isReecived
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
              'إستقبال تبرع جديد',
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
              label: "المبلغ المستقبل بالارقام",
              obsecure: false,
              controller: sommeController,
            ),
            const SizedBox(height: 20),
            Mytextfield(
              label: "المبلغ المستقبل بالحروف",
              obsecure: false,
              controller: lettreController,
            ),
            const SizedBox(height: 20),
            Mutation(
  options: MutationOptions(
    document: gql(recieveDonation),
    onCompleted: (dynamic resultData) {
      if (resultData != null) {
        print("Donation received: $resultData");
      }
    },
    onError: (error) {
      print("Error occurred: $error");
    },
  ),
  builder: (RunMutation runMutation, QueryResult? result) {
    return ElevatedButton(
      onPressed: () {
        // Ensure the text is not empty and is a valid number
        if (sommeController.text.isEmpty || int.tryParse(sommeController.text) == null) {
          print("Invalid input for price");
          // Optionally show an error message to the user
          return;
        }

        // Parse the price and ensure it's an integer
        final int price = int.parse(sommeController.text.trim());
        print("Parsed price: $price");

        // Run the mutation
        runMutation({
          'DonnationId': donnationId,
          'ProjectId': projectId,
          'MosqueeId': mosqueeId,
          'price': price,  // Ensure this is an integer
        });
        
        Navigator.pop(context);
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

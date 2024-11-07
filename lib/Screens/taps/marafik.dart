import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MarafikScreen extends StatelessWidget {
  final String mosqueeId;

  const MarafikScreen({super.key, required this.mosqueeId});

  @override
  Widget build(BuildContext context) {
    // Define your query
    String getMosqueeQuery = """
    query GetMosquee(\$id: ID!) {
      getMosquee(id: \$id) {
        ... on Error {
          message
        }
        ... on Mosque {
          mosqueeName
          id
          password
          project {
            ... on project {
            id
              marafik {
                marafik
                avanceTravail
              }
            }
          }
        }
      }
    }
    """;

    return Scaffold(
      body: Query(
        options: QueryOptions(
          document: gql(getMosqueeQuery),
          variables: {'id': mosqueeId},
        ),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // Extract data from the result
          final mosqueData = result.data?['getMosquee'];
          if (mosqueData == null || mosqueData['project'] == null || mosqueData['project']['marafik'] == null) {
            return Center(child: Text('No data available'));
          }

          final List<dynamic> marafikList = mosqueData['project']['marafik'];
          final projectId = mosqueData['project']['id'];
          return ListView.builder(
            itemCount: marafikList.length,
            itemBuilder: (context, index) {
              final marfek = marafikList[index]['marafik'] ?? 'Unknown';
              final avanceTravail = marafikList[index]['avanceTravail']?.toString() ?? '0';

              return PercentageCard(
                marfek: marfek,
                pourcentage: avanceTravail,
                mosqueeId: projectId, 
              );
            },
          );
        },
      ),
    );
  }
}

class PercentageCard extends StatefulWidget {
  final String marfek;
  final String pourcentage;
  final String mosqueeId;
  const PercentageCard({super.key, required this.marfek, required this.pourcentage, required this.mosqueeId, });

  @override
  _PercentageCardState createState() => _PercentageCardState();
}
class _PercentageCardState extends State<PercentageCard> {
  late int percentage;
  String? _errorText; // To store the error message

  @override
  void initState() {
    super.initState();
    percentage = int.tryParse(widget.pourcentage) ?? 0;
  }

  void _showEditDialog() {
    TextEditingController controller = TextEditingController(text: percentage.toString());

    // Define the mutation
    String updateMarafikMutation = """
    mutation UpdateMarafik(\$id: ID, \$marafik: String, \$avanceTravail: Int) {
      updateMarafik(id: \$id, marafik: \$marafik, avanceTravail: \$avanceTravail) {
        ... on Error {
          message
        }
        ... on project {
          marafik {
            marafik
            avanceTravail
          }
        }
      }
    }
    """;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('تحديث نسبة تقدم المشروع'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "يرجى ادخال القيمة الجديدة",
                      errorText: _errorText, // Show error text if it's set
                    ),
                    onChanged: (value) {
                      // Reset the error message when the user starts typing
                      setState(() {
                        _errorText = null;
                      });
                    },
                  ),
                  if (_errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _errorText!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Mutation(
                  options: MutationOptions(
                    document: gql(updateMarafikMutation),
                    onError: (error) {
                      print('Error editing marfek: $error');
                    },
                    onCompleted: (dynamic resultData) {
                      print("Update done: $resultData");
                    },
                  ),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    return TextButton(
                      child: Text('Save'),
                      onPressed: () {
                        final newValue = int.tryParse(controller.text);
                        if (newValue == null || newValue < 0) {
                          
                          // Show error if the input is invalid or negative
                          setState(() {
                            _errorText = 'الرجاء إدخال قيمة موجبة و بدون فاصل';
                          });
                        } else {
                          // Update the percentage and run the mutation
                          setState(() {
                            percentage = newValue;
                            _errorText = null;
                          });
                          runMutation({
                            'id': widget.mosqueeId,
                            'marafik': widget.marfek,
                            'avanceTravail': newValue,
                          });
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _showEditDialog,
                ),
                Text(
                  widget.marfek,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

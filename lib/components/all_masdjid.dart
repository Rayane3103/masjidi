import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/add_mofawad.dart';

const String getAllMosqueesQuery = """
  query {
    getAllMosquees {
      ... on Error {
        message
      }
      ... on Mosque {
        mosqueeName
        id
        
      }
    }
  }
""";

class AllMasdjid extends StatelessWidget {
  final String projectDay;
  final String projectId;
  const AllMasdjid({super.key, required this.projectId, required this.projectDay});

  @override
  Widget build(BuildContext context) {
    return  Query(
        options: QueryOptions(
          document: gql(getAllMosqueesQuery),
        ),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
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

          final List mosques = result.data?['getAllMosquees'] ?? [];

          return ListView.builder(
            itemCount: mosques.length,
            itemBuilder: (BuildContext context, int index) {
              final mosque = mosques[index];
              final mosqueId=mosque['id'];
              return InkWell(
                onTap: () {
Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => AddDonationPage(mosqueId: mosqueId, projectId:projectId ,projectDay:projectDay),
    ),
  );                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
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
                            child: const Center(
                              child: Icon(Icons.chevron_left,color: Colors.white,),
                            ),
                          ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          
                          Text(
                            mosque['mosqueeName'] ?? 'Unknown',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "2024-10-04",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      
    );
  }
}

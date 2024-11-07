import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/add_tabaro3.dart';

class Tabaro3atScreen extends StatefulWidget {
  final String mosqueeId;
    final String? fridayId;
    final String day;
  Tabaro3atScreen({super.key, required this.mosqueeId,required this.fridayId, required this.day});

  @override
  State<Tabaro3atScreen> createState() => _Tabaro3atScreenState();
}

class _Tabaro3atScreenState extends State<Tabaro3atScreen> {
  String query = """
    query getMosquee(\$id: ID!) {
      getMosquee(id: \$id) {
        ... on Error {
          message
        }
        ... on Mosque {
          mosqueeName
          donnations {
            id
            project
            projectName
            mofaoudName
            mofaoudCard
            mosquee
            day
            price
            isReecived
          }
        }
      }
    }
  """;

  @override
  Widget build(BuildContext context) {

    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Query(
          options: QueryOptions(
            document: gql(query),
            variables: {'id': widget.mosqueeId},
              fetchPolicy: FetchPolicy.noCache,
          ),
          builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.isLoading) {
              return Center(child: CircularProgressIndicator(color: primaryColor,));
            }

            if (result.isLoading) {
          return Center(child: CircularProgressIndicator(color: primaryColor,));
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

            final mosquee = result.data!['getMosquee'];
            if (mosquee['__typename'] == 'Error') {
              return Center(child: Text(mosquee['message']));
            }
            final donations = mosquee['donnations'] as List<dynamic>;
            if (donations.isNotEmpty){
            return ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
final donation = donations[donations.length - 1 - index];
                if (donation['price']==null) {
                  return InkWell(
                  onTap: () async{
                    if (widget.fridayId !=null) {
                      final newTabaro3 = await Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) => 
                        AddTabaro3(
                          projectId: widget.fridayId!,
                           mosqueeId: widget.mosqueeId,
                            donnationId: donation['id'],
                             day:widget.day,
                             myRefetch: refetch,
                             ),));
                          if (newTabaro3!=null) {
                            setState(() {
                              donations.add(newTabaro3);
                            });
                          }
              } 
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal:20),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height*0.09,
                      decoration: BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.circular(20), 
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), 
                                  blurRadius: 7.5,  
                                  offset: Offset(3, 2), 
                                ),
                              ],
                            ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${donation['projectName']}',
                                  style: TextStyle(
                                    color:Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  donation['day'].toString().split(' ')[0],
                                  style: const TextStyle(color: Colors.grey,fontSize: 11),
                                ),
                              ],
                            ),
                            Container(
                              height: 37,
                              width: 37,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: Center(
                                child: Image.asset('assets/icons/hand.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                
                }
                else
                if (donation['price']!=null && donation['isReecived']==false) {
                  return InkWell(
                  onTap: () {
                    
                    showModalBottomSheet(context: context, builder: (BuildContext context){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "المجموع:",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  '${donation['price']} DA',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "المشروع:",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  donation['projectName'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "التاريخ:",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  donation['day'].toString().split(' ')[0],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "المكلف:",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  donation['mofaoudName'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.center,
                                  child: (donation['mofaoudCard']!='لا يوجد بطاقة')? Image.network(donation['mofaoudCard']): Image.asset('assets/images/id.png'),
                                ),
                              ],
                            ),
                      );
                      
                      });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal:20),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height*0.09,
                      decoration: BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.circular(20), 
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), 
                                  blurRadius: 7.5,  
                                  offset: Offset(3, 2), 
                                ),
                              ],
                            ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  textDirection:TextDirection.rtl,
                                  ' ${donation['price']} دج',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                                                    textDirection:TextDirection.rtl,

                                  donation['day'].toString().split(' ')[0],
                                  style: const TextStyle(color: Colors.grey,fontSize: 12),
                                ),
                              ],
                            ),
                            Container(
                              height: 37.5,
                              width: 37.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: secondaryColor,
                              ),
                              child: Center(
                                child: Icon(Icons.info_outlined,color: Colors.white,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                }
                else{
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(context: context, builder: (BuildContext context){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "المجموع:",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  '${donation['price']} DA',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "المشروع:",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  donation['projectName'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "التاريخ:",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  donation['day'].toString().split(' ')[0],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "المكلف:",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  donation['mofaoudName'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.center,
                                  child: (donation['mofaoudCard']!='لا يوجد بطاقة')? Image.network(donation['mofaoudCard']): Image.asset('assets/images/id.png'),
                                ),
                              ],
                            ),
                      );
                      
                      });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal:20),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height*0.09,
                      decoration: BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.circular(20), 
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), 
                                  blurRadius: 7.5,  
                                  offset: Offset(3, 2), 
                                ),
                              ],
                            ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  textDirection:TextDirection.rtl,
                                  ' ${donation['price']} دج',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                                                    textDirection:TextDirection.rtl,

                                  donation['day'].toString().split(' ')[0],
                                  style: const TextStyle(color: Colors.grey,fontSize: 12),
                                ),
                              ],
                            ),
                            Container(
                              height: 37.5,
                              width: 37.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              child: Center(
                                child: Icon(Icons.info_outlined,color: Colors.white,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );}
              },
            );}
            else{
              return Center(child:Text('لا يوجد تبرعات في هذاالمسجد'));
            }
          },
        ),
     
    );
  }
}

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/recieve_tabaro3.dart';

class Tabaro3atScreen2 extends StatefulWidget {
  final String mosqueeId;

  Tabaro3atScreen2({super.key, required this.mosqueeId});

  @override
  State<Tabaro3atScreen2> createState() => _Tabaro3atScreen2State();
}

class _Tabaro3atScreen2State extends State<Tabaro3atScreen2> {
  String query = """
    query getMosquee(\$id: ID!) {
      getMosquee(id: \$id) {
        ... on Error {
          message
        }
        ... on Mosque {
          mosqueeName
           project{
      ... on Error{message}
      ... on project{
      id
        DonnationRecived{
          id
          mosquee
          mosqueeName
          priceRecived
          price
          day
          mofaoudName
          mofaoudCard
          isReecived
        }
      }
    }
        }
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);

    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
            final projectId = (mosquee['project'] != null)? mosquee['project']['id']:'';
            final donations = (mosquee['project'] != null && mosquee['project']['DonnationRecived'] != null)
    ? List<Map<String, dynamic>>.from(mosquee['project']['DonnationRecived'])
    : [];

if (donations.isNotEmpty) {
  return ListView.builder(
    itemCount: donations.length,
    itemBuilder: (context, index) {
final donation = donations[donations.length - 1 - index];
      final donationId = donation['id'];
      final isRecieved = donation['isReecived'];
      if (isRecieved == true) {
        return InkWell(
                  onTap: () {
  final day = donation['day']?.toString() ?? 'التاريخ غير محدد';
  final mosqueeName = donation['mosqueeName'] ?? 'اسم المسجد غير متوفر';
  final donationPrice = donation['priceRecived'] ?? 'غير متوفر';
  final mofaoudName = donation['mofaoudName'] ?? 'غير متوفر';

  // Logging the values for debugging
  print('Mosquee Name: $mosqueeName');
  print('Price: $donationPrice');
  print('Day: $day');
  print('Mofaoud Name: $mofaoudName');
showModalBottomSheet(context: context, builder: (BuildContext context){
return Padding(
  padding: const EdgeInsets.all(20.0),
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
                '$donationPrice DA',
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
                mosqueeName,
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
                day,
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
                mofaoudName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height:MediaQuery.sizeOf(context).height*0.11,
                  width: MediaQuery.sizeOf(context).width*0.65,
                  child: Image.asset('assets/images/id.png')),
              ),
            ],
          ),
);
});
  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16.0),
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           Text(
  //             "المجموع:",
  //             style: TextStyle(
  //               color: secondaryColor,
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textDirection: TextDirection.rtl,
  //           ),
  //           Text(
  //             '$donationPrice DA',
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             "المشروع:",
  //             style: TextStyle(
  //               color: secondaryColor,
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textDirection: TextDirection.rtl,
  //           ),
  //           Text(
  //             mosqueeName,
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             "التاريخ:",
  //             style: TextStyle(
  //               color: secondaryColor,
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textDirection: TextDirection.rtl,
  //           ),
  //           Text(
  //             day,
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             "المكلف:",
  //             style: TextStyle(
  //               color: secondaryColor,
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textDirection: TextDirection.rtl,
  //           ),
  //           Text(
  //             mofaoudName,
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 16),
  //           Align(
  //             alignment: Alignment.center,
  //             child: Image.asset('assets/images/id.png'),
  //           ),
  //         ],
  //       ),
  //     );
  //   },
  // );
},

                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal:16),
                    child: Container(
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
                              height: 37.5,
                              width: 37.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              child: Center(
                                child:  Icon(Icons.info_outlined,color: Colors.white,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
      }else{
return InkWell(
                  onTap: () {
  final day = donation['day']?.toString() ?? 'التاريخ غير محدد';
  final mosqueeName = donation['mosqueeName'] ?? 'اسم المسجد غير متوفر';
  final donationPrice = donation['priceRecived'] ?? 'غير متوفر';
  final mofaoudName = donation['mofaoudName'] ?? 'غير متوفر';

  // Logging the values for debugging
  print('Mosquee Name: $mosqueeName');
  print('Price: $donationPrice');
  print('Day: $day');
  print('Mofaoud Name: $mofaoudName');


          Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) =>  RecieveTabaro3(projectId: projectId, mosqueeId: widget.mosqueeId, donnationId: donationId, day: day,),
    ),
  );
                  },
  
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal:20),
                    child: Container(
                      
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
                                  '${donation['mosqueeName']}',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                 'يرجي إضافة المبلغ المستقبل',
                                  style: const TextStyle(color: Colors.grey,fontSize: 11),
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
                                child: Icon(Icons.add,color: Colors.white,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
      );
      }
                
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

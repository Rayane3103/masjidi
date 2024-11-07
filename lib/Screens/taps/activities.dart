import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';

class Activities extends StatelessWidget {
    final String mosqueeId;

  const Activities({super.key, required this.mosqueeId});
String getImamActivities(String mosqueeId) {
    return """
    query {
      getMosquee(id: "$mosqueeId") {
        ... on Error {
          message
        }
        ... on Mosque {
          imam{
      employee{name}
      Activity{
        title
      	date
        type
      }
    }
        }
      }
    }
    """;
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getImamActivities(mosqueeId)),
        fetchPolicy: FetchPolicy.noCache
      ),
       builder: (QueryResult result, {refetch, fetchMore}){
        if (result.isLoading) {
          return Center(child: CircularProgressIndicator(color: primaryColor,));
        }

        if (result.hasException) {
          print(result.exception);
          return Text('Error: ${result.exception.toString()}');
        }
        final  activities = result.data?['getMosquee']['imam']?['Activity'];
        if (activities == null || activities is List == false){
          return Center(child: Text("لا يوجد  نشاطات"));
        }
      
      return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (buildContext, index) {
       final String title = activities[index]['title'];
       final String date = activities[index]['date'];
       final String type = activities[index]['type'];
        return ActivityCard(description: '', title: title, date: date, type: type,);
      },
    );
       });
    
}}

class ActivityCard extends StatelessWidget {
  final String title;
  final String date;
  final String type;
  final String description;
  const ActivityCard({super.key, required this.title, required this.date, required this.type, required this.description});

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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date),
                Text(
                            textDirection: TextDirection.rtl,

                  type,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF154c41), 
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), 
            Directionality(
               textDirection: TextDirection.rtl,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
              
                    style: TextStyle(
                      fontSize: 16.0,
                      color: secondaryColor,
                    ),
                  ),
                ]
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(maxLines: 3, 
                overflow: TextOverflow.ellipsis,'تقوى الله هي الالتزام بأوامره واجتناب نواهيه، وهي أساس حياة المسلم الصالح. فالإنسان المتقي يسعى دائمًا إلى القرب من الله من خلال أداء العبادات والابتعاد عن المعاصي. أما الخلق الحسن، فهو التعامل مع الآخرين بالصدق، والعدل، والرحمة،'),
              
            ),
          ],
        ),
      ),
    );}}

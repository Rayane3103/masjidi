import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';

class EmployeeList extends StatelessWidget {
  final String mosqueeId;

  EmployeeList({super.key, required this.mosqueeId});

  String getEmployeesQuery(String mosqueeId) {
    return """
    query {
      getMosquee(id: "$mosqueeId") {
        ... on Error {
          message
        }
        ... on Mosque {
          employee {
            ... on Error {
              message
            }
            ... on Employee {
              name
              role
              taklif
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
        fetchPolicy: FetchPolicy.noCache,
        document: gql(getEmployeesQuery(mosqueeId)),
        
      ),
      builder: (QueryResult result, {refetch, fetchMore}) {
        if (result.hasException) {
          return Center(child: Text(result.exception.toString()));
        }

        if (result.isLoading) {
          return Center(child: CircularProgressIndicator(color: primaryColor,));
        }

        final employees = result.data?['getMosquee']['employee'];

        if (employees == null || employees is List == false) {
          return Center(child: Text("No employees found"));
        }

        return ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return EmployeeCard(
              name: employee['name'] ?? 'Unknown',
              role: employee['role'] ?? 'Unknown',
              taklif: employee['taklif'] ?? 'Unknown',
            );
          },
        );
      },
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final String name;
  final String role;
  final String taklif;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.role,
    required this.taklif,
  });

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
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
                Text(
                  name,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF154c41), // Dark green color
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add some space between rows
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'الرتبة : ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: secondaryColor,
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor, // Same dark green color
                    ),
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'التكليف : ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: secondaryColor,
                    ),
                  ),
                  Text(
                    taklif,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

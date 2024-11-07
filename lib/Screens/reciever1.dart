import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/components/2screentabaro3at.dart';
import 'package:masjidi/components/all_masdjid.dart';
import 'package:masjidi/components/tabaro3atscreen.dart';

class Reciever1 extends StatefulWidget {
  final Map<String, dynamic>? resultData;
  final String projectId;
  final String projectDay;
  const Reciever1({super.key, required this.resultData, required this.projectId, required this.projectDay});

  @override
  State<Reciever1> createState() => _Reciever1State();
}

class _Reciever1State extends State<Reciever1> with SingleTickerProviderStateMixin {
  String recieveDonation = """
    mutation ReciveDonnation(\$DonnationId: ID!, \$ProjectId: ID!, \$MosqueeId: ID!, \$price: Int!) {
      ReciveDonnation(DonnationId: \$DonnationId, ProjectId: \$ProjectId, MosqueeId: \$MosqueeId, price: \$price) {
   
   ... on project{
    id
    DonnationRecived{
      id
      mosqueeName
      price
      mofaoudName
      isReecived
    }
  }
    }}
  """;


  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); 
  }

  @override
  void dispose() {
    _tabController.dispose(); 
    super.dispose();
  }

  void _handleRecieveDonation() async {
    final client = GraphQLProvider.of(context).value;

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(recieveDonation),
          variables: {
            'DonnationId': "670accd992d45bb219ea21b6",
            'ProjectId': "66e62ee184d2688deb4adcba",
            'MosqueeId': "66ec3c7954017efd537ef0fd",
            'price': "12333",
          },
        ),
      );

      if (result.hasException) {
        print('Mutation Error: ${result.exception.toString()}');
      } else {
        print('Donation received: ${result.data}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    final mosqueName = widget.resultData!['loginMosquee']['mosqueeName'];
    final mosqueId = widget.resultData!['loginMosquee']['id'];

    return Column(
      children: [
        
        TabBar(
          controller: _tabController, 
          tabs: const [
            Tab(text: "المخاريج"),
            Tab(text: "المداخيل"),
            Tab(text: "المفوضين"),
          ],
          indicatorColor: primaryColor,
          labelColor: primaryColor,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController, 
            children: [
              Tabaro3atScreen(mosqueeId: mosqueId, fridayId: widget.projectId, day: widget.projectDay,),
              Tabaro3atScreen2(mosqueeId: mosqueId),
              AllMasdjid(projectId: widget.projectId,projectDay: widget.projectDay,),
            ],
          ),
        ),
        // SizedBox(
        //   width: screenSize.width * 0.75,
        //   child: ElevatedButton(
        //     onPressed: _handleRecieveDonation,
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.white,
        //       foregroundColor: primaryColor,
        //       padding: const EdgeInsets.symmetric(vertical: 10.0),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(30.0),
        //       ),
        //     ),
        //     child: const Text(
        //       "إستقبال تبرع",
        //       style: TextStyle(fontSize: 18.0),
        //     ),
        //   ),
        // ),
        
      ],
    );
  }
}

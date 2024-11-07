import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/loginpage.dart';

class MySplashScreen extends StatefulWidget {
      final ValueNotifier<GraphQLClient> client;

   MySplashScreen({super.key, required this.client, });

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> with SingleTickerProviderStateMixin {
  @override

  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>  LoginPage(client: widget.client,)));});
    }
    
     
  
  @override
  Widget build(BuildContext context) {
        final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(child: 
      Padding(
        padding:  EdgeInsets.only(top:screenHeight*0.3,bottom: 20),
        child: Column(children: [
          Image.asset('assets/images/Logo.png'),
          const Spacer(),
          const Text('Developped by k-Linker agency',style: TextStyle(color: Colors.white),)
          ],),
      ),
        ),
    );
  }
}
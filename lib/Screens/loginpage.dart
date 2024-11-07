import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/firsttime/masjid_infopage.dart';
import 'package:masjidi/components/mytextfield.dart';

class LoginPage extends StatefulWidget {
  final ValueNotifier<GraphQLClient> client;

  const LoginPage({Key? key, required this.client}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mosqueIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mutation(
        options: MutationOptions(
          document: gql(r'''
            mutation LoginMosquee($id: ID!, $password: String!) {
              loginMosquee(id: $id, password: $password) {
                __typename
                ... on Error{message}
                ... on Mosque {
                  id
                  mosqueeName
                  location
                  imam{employee{
                  
      name
      contact
    }}
               

                  }
                }
              }
            
          '''),

          onCompleted: (resultData) {
                               
            if (resultData != null) {
              print(resultData);
              if (resultData['loginMosquee']['__typename']!="Error") {
                final mosqueName = resultData['loginMosquee']['mosqueeName'];
              FocusScope.of(context).unfocus();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MosqueInfoPage(resultData: resultData)),
              );
              }
              else{
                final String e_message = resultData['loginMosquee']['message'];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e_message),
                      ));
              }
              
            }
          },

          onError: (error) {
            print('GraphQL Error: ${error.toString()}');
            String errorMessage = 'Login failed. Please check your network connection.';
            if (error?.graphqlErrors.isNotEmpty ?? false) {
              errorMessage = error?.graphqlErrors.first.message ?? errorMessage;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('الرجاء التأكد من رقم المسجد')),
            );
          },
        ),
        builder: (RunMutation runMutation, QueryResult? result) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Image.asset(
                'assets/images/loggo.png',
                height: 250,
                color: primaryColor,
              ),
              const SizedBox(height: 40),
              Mytextfield(
                icon: Image.asset("assets/icons/jama3.png", height: 50,color:primaryColor),
                label: "رقم المسجد",
                obsecure: false,
                controller: _mosqueIdController,
              ),
              Mytextfield(
                icon: Icon(Icons.lock, color: primaryColor, size: 35),
                label: 'كلمة المرور',
                obsecure: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 40),
              Container(
                height: 60,
                child: ElevatedButton(
                  onPressed: result?.isLoading ?? false
                      ? null // Disable the button while loading
                      : () {
                          // Trigger the mutation
                          runMutation({
                            'id': _mosqueIdController.text,
                            'password': _passwordController.text,
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: result?.isLoading ?? false
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text("تأكيد",style: TextStyle(fontSize:18 ),),
                ),
              ),
              if (result?.hasException ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'An error occurred. Please try again.',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

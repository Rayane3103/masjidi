import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Screens/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  final client = GraphQLClient(
    cache: GraphQLCache(
    store: InMemoryStore(), // This prevents caching from persisting
  ), 
    link: HttpLink('https://masjidiprivate.onrender.com/graphql'),
  );

  runApp(MyApp(client: ValueNotifier(client)));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(color: Colors.white),
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(client: client),
      ),
    );
  }
}

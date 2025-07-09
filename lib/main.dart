import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'core/graphql/client.dart';
import 'screens/screens.dart' as screens;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(MyApp(client: GraphQLService.initClient()));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Personal Finance Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const screens.OnboardingScreen(),
          '/login': (context) => const screens.LoginScreen(),
        },
      ),
    );
  }
}
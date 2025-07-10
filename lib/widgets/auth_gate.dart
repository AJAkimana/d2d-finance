import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:d2d_finance/services/storage_service.dart';
import 'package:d2d_finance/screens/screens.dart' as screens;
import 'package:d2d_finance/core/graphql/queries/user.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> isAuthenticated(GraphQLClient client) async {
    final token = await StorageService.get('auth_token');
    if (token == null || token.isEmpty) return false;

    final result = await client.query(
      QueryOptions(
        document: gql(GET_USER_AUTH_INFO),
        fetchPolicy: FetchPolicy.networkOnly,
        context: Context().withEntry(
          HttpLinkHeaders(headers: {'Authorization': 'Bearer $token'}),
        ),
      ),
    );
    return result.data != null && result.data!['me'] != null;
  }

  @override
  Widget build(BuildContext context) {
    final client = GraphQLProvider.of(context).value;
    return FutureBuilder<bool>(
      future: isAuthenticated(client),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == true) {
          return const screens.DashboardScreen();
        } else {
          return const screens.LoginScreen();
        }
      },
    );
  }
}
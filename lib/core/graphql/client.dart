import 'package:d2d_finance/services/storage_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphQLService {
  static final HttpLink httpLink =
      HttpLink('http://localhost:8000/api/d2dstore/');

  static ValueNotifier<GraphQLClient> initClient() {
    final AuthLink authLink = AuthLink(
      getToken: () async => 'JWT ${await StorageService.get('auth_token')}',
    );
    final Link link = authLink.concat(httpLink);
    return ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }
}

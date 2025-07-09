import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphQLService {
  static final HttpLink httpLink = HttpLink('http://192.168.1.130:8000/api/d2dstore/');

  static ValueNotifier<GraphQLClient> initClient() {
    return ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }
}
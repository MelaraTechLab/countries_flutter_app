import 'package:flutter/foundation.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> buildGraphQLClient() {
  final endpoint = dotenv.env['GRAPHQL_ENDPOINT'];
  if (endpoint == null || endpoint.isEmpty) {
    throw StateError('GRAPHQL_ENDPOINT missing in .env');
  }
  return ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(endpoint),
    ),
  );
}
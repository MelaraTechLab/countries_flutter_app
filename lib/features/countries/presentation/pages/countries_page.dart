import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_client.dart';

const countriesQuery = r'''
  query Countries {
    countries {
      code
      name
      emoji
      continent { name }
      languages { name }
    }
  }
''';

class CountriesPage extends StatelessWidget {
  const CountriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = buildGraphQLClient();
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(title: const Text('Countries (GraphQL)')),
        body: Query(
          options: QueryOptions(document: gql(countriesQuery)),
          builder: (result, {refetch, fetchMore}) {
            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (result.hasException) {
              return Center(child: Text('Error: ${result.exception}'));
            }
            final list = (result.data?['countries'] as List?) ?? [];
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final c = list[i];
                final langs = ((c['languages'] as List?) ?? [])
                    .map((e) => e['name'])
                    .join(', ');
                return ListTile(
                  leading: Text(c['emoji'] ?? ''),
                  title: Text(c['name'] ?? ''),
                  subtitle: Text(
                    '${c['code']} • ${c['continent']?['name'] ?? ''}${langs.isNotEmpty ? " • $langs" : ""}',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

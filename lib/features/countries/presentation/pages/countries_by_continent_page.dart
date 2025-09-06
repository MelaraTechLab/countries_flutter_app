// lib/features/countries/presentation/pages/countries_by_continent_page.dart
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_client.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/footer_nav.dart';

const continentQuery = r'''
  query Continent($code: ID!) {
    continent(code: $code) {
      name
      countries {
        code
        name
        emoji
        languages { name }
      }
    }
  }
''';

class CountriesByContinentPage extends StatelessWidget {
  final String continentCode;
  const CountriesByContinentPage({super.key, required this.continentCode});

  @override
  Widget build(BuildContext context) {
    final client = buildGraphQLClient();
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(title: Text('Countries • $continentCode')),
        bottomNavigationBar: const FooterNav(),
        body: Query(
          options: QueryOptions(
            document: gql(continentQuery),
            variables: {'code': continentCode},
          ),
          builder: (result, {refetch, fetchMore}) {
            if (result.isLoading) return const Center(child: CircularProgressIndicator());
            if (result.hasException) {
              return Center(child: Text('Error: ${result.exception}'));
            }
            final continent = result.data?['continent'];
            final list = (continent?['countries'] as List?) ?? [];
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final c = list[i];
                final langs = ((c['languages'] as List?) ?? []).map((e) => e['name']).join(', ');
                return ListTile(
                  leading: Text(c['emoji'] ?? ''),
                  title: Text(c['name'] ?? ''),
                  subtitle: Text('${c['code'] ?? ''}${langs.isNotEmpty ? " • $langs" : ""}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/country/${c['code']}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
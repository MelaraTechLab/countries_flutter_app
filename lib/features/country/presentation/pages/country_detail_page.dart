import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_client.dart';
import '../../../common/widgets/footer_nav.dart';

const countryQuery = r'''
  query Country($code: ID!) {
    country(code: $code) {
      name
      native
      capital
      currency
      phone
      emoji
      continent { name }
      languages { name }
    }
  }
''';

class CountryDetailPage extends StatelessWidget {
  final String countryCode;
  const CountryDetailPage({super.key, required this.countryCode});

  @override
  Widget build(BuildContext context) {
    final client = buildGraphQLClient();
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(title: Text('Country • $countryCode')),
        bottomNavigationBar: const FooterNav(),
        body: Query(
          options: QueryOptions(
            document: gql(countryQuery),
            variables: {'code': countryCode},
          ),
          builder: (result, {refetch, fetchMore}) {
            if (result.isLoading) return const Center(child: CircularProgressIndicator());
            if (result.hasException) {
              return Center(child: Text('Error: ${result.exception}'));
            }
            final c = result.data?['country'];
            if (c == null) return const Center(child: Text('Country not found'));
            final langs = ((c['languages'] as List?) ?? []).map((e) => e['name']).join(', ');
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(c['emoji'] ?? '', style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 12),
                Text(c['name'] ?? '', style: Theme.of(context).textTheme.headlineSmall),
                if ((c['native'] ?? '').toString().isNotEmpty)
                  Text('(${c['native']})', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                _kv('Capital', c['capital']),
                _kv('Continent', c['continent']?['name']),
                _kv('Currency', c['currency']),
                _kv('Phone code', c['phone'] != null ? '+${c['phone']}' : null),
                _kv('Languages', langs.isNotEmpty ? langs : null),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _kv(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
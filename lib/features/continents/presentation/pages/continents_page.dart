import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_client.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/footer_nav.dart';

const continentsQuery = r'''
  query {
    continents {
      code
      name
      countries { code }  # solo para contar
    }
  }
''';

class ContinentsPage extends StatelessWidget {
  const ContinentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = buildGraphQLClient();
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(title: const Text('Continents')),
        bottomNavigationBar: const FooterNav(),
        body: Query(
          options: QueryOptions(document: gql(continentsQuery)),
          builder: (result, {refetch, fetchMore}) {
            if (result.isLoading) return const Center(child: CircularProgressIndicator());
            if (result.hasException) {
              return Center(child: Text('Error: ${result.exception}'));
            }
            final list = (result.data?['continents'] as List?) ?? [];
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final c = list[i];
                final count = (c['countries'] as List?)?.length ?? 0;
                return ListTile(
                  title: Text(c['name'] ?? ''),
                  subtitle: Text('${c['code']} • $count countries'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/continents/${c['code']}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
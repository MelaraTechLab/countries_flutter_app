import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/network/graphql_client.dart';
import '../../../common/widgets/footer_nav.dart';

const _brand = Color(0xFF3A5683);

const _continentsQuery = r'''
  query {
    continents {
      code
      name
      countries { code }  # solo para contar
    }
  }
''';

class ContinentsPage extends StatefulWidget {
  const ContinentsPage({super.key});

  @override
  State<ContinentsPage> createState() => _ContinentsPageState();
}

class _ContinentsPageState extends State<ContinentsPage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = buildGraphQLClient();

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explorar por Continente'),
          centerTitle: false,
        ),
        bottomNavigationBar: const FooterNav(),
        body: Query(
          options: QueryOptions(document: gql(_continentsQuery)),
          builder: (result, {refetch, fetchMore}) {
            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (result.hasException) {
              return Center(child: Text('Error: ${result.exception}'));
            }

            final list = (result.data?['continents'] as List?) ?? [];
            final term = _searchCtrl.text.trim().toLowerCase();
            final filtered = term.isEmpty
                ? list
                : list.where((c) {
                    final name = (c['name'] ?? '').toString().toLowerCase();
                    final code = (c['code'] ?? '').toString().toLowerCase();
                    return name.contains(term) || code.contains(term);
                  }).toList();

            return Column(
              children: [
                // buscador
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Buscar continente',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: _brand, width: 1.4),
                      ),
                    ),
                  ),
                ),

                // subtítulo
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Continentes',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // lista
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final c = filtered[i];
                      final name = c['name'] ?? '';
                      final code = c['code'] ?? '';
                      final count = (c['countries'] as List?)?.length ?? 0;

                      return _ContinentCard(
                        name: name,
                        code: code,
                        count: count,
                        onTap: () {
                          Navigator.of(context).pushNamed('/continents/$code');
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ContinentCard extends StatelessWidget {
  final String name;
  final String code;
  final int count;
  final VoidCallback onTap;

  const _ContinentCard({
    required this.name,
    required this.code,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _brand.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: _brand.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // icono dentro de “pill”
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _brand.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.public, color: _brand),
              ),

              const SizedBox(width: 12),

              // textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$count ${count == 1 ? "país" : "países"}',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.65),
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

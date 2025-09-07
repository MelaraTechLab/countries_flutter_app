import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/network/graphql_client.dart';
import '../../../common/widgets/footer_nav.dart';

const _brand = Color(0xFF3A5683);

const _continentQuery = r'''
  query Continent($code: ID!) {
    continent(code: $code) {
      name
      code
      countries {
        code
        name
        emoji
        languages { name }
      }
    }
  }
''';

class CountriesByContinentPage extends StatefulWidget {
  final String continentCode;
  const CountriesByContinentPage({super.key, required this.continentCode});

  @override
  State<CountriesByContinentPage> createState() =>
      _CountriesByContinentPageState();
}

class _CountriesByContinentPageState extends State<CountriesByContinentPage> {
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
        appBar: AppBar(title: const Text('Países')),
        bottomNavigationBar: const FooterNav(),
        body: Query(
          options: QueryOptions(
            document: gql(_continentQuery),
            variables: {'code': widget.continentCode},
          ),
          builder: (result, {refetch, fetchMore}) {
            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (result.hasException) {
              return Center(child: Text('Error: ${result.exception}'));
            }

            final continent = result.data?['continent'];
            final continentNameEn = (continent?['name'] ?? '') as String;
            final continentNameEs = _continentEs(continentNameEn);

            final list = (continent?['countries'] as List?) ?? [];
            final term = _searchCtrl.text.trim().toLowerCase();
            final filtered = term.isEmpty
                ? list
                : list.where((c) {
                    final name = (c['name'] ?? '').toString().toLowerCase();
                    final code = (c['code'] ?? '').toString().toLowerCase();
                    return name.contains(term) || code.contains(term);
                  }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // buscador
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre o ISO',
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
                  child: Text(
                    'Lista de Países',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                      final iso = (c['code'] ?? '') as String;
                      final name = (c['name'] ?? '') as String;
                      final emoji = (c['emoji'] ?? '') as String;
                      final langs = ((c['languages'] as List?) ?? [])
                          .map((e) => (e['name'] ?? '').toString())
                          .where((s) => s.isNotEmpty)
                          .join(', ');

                      return _CountryCard(
                        emoji: emoji,
                        name: name,
                        iso: iso,
                        continentEs: continentNameEs,
                        languages: langs,
                        onTap: () {
                          Navigator.of(context).pushNamed('/country/$iso');
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

class _CountryCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String iso;
  final String continentEs;
  final String languages;
  final VoidCallback onTap;

  const _CountryCard({
    required this.emoji,
    required this.name,
    required this.iso,
    required this.continentEs,
    required this.languages,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _brand.withOpacity(0.22)),
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
              // banderita/emoji
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _brand.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),

              // textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // línea principal
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '• ISO: $iso • $continentEs',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.65),
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      languages.isNotEmpty
                          ? 'Idiomas: $languages'
                          : 'Idiomas: —',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.70),
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

// Traducción simple de nombres de continente
String _continentEs(String en) {
  switch (en) {
    case 'Europe':
      return 'Europa';
    case 'Asia':
      return 'Asia';
    case 'Africa':
      return 'África';
    case 'Oceania':
      return 'Oceanía';
    case 'North America':
    case 'South America':
    case 'Americas':
      return 'América';
    case 'Antarctica':
      return 'Antártida';
    default:
      return en;
  }
}

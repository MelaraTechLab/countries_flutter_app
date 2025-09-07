import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/graphql_client.dart';
import '../../../common/widgets/footer_nav.dart';

const _brand = Color(0xFF3A5683);

const _countryQuery = r'''
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
        appBar: AppBar(title: const Text('Detalle de País')),
        bottomNavigationBar: const FooterNav(),
        body: Query(
          options: QueryOptions(
            document: gql(_countryQuery),
            variables: {'code': countryCode},
          ),
          builder: (result, {refetch, fetchMore}) {
            if (result.isLoading) return const Center(child: CircularProgressIndicator());
            if (result.hasException) {
              return Center(child: Text('Error: ${result.exception}'));
            }

            final c = result.data?['country'];
            if (c == null) return const Center(child: Text('País no encontrado'));

            final name = (c['name'] ?? '') as String;
            final nativeName = (c['native'] ?? '') as String?;
            final emoji = (c['emoji'] ?? '') as String?;
            final capital = (c['capital'] ?? '') as String?;
            final continentEn = (c['continent']?['name'] ?? '') as String;
            final continentEs = _continentEs(continentEn);
            final currency = (c['currency'] ?? '') as String?;
            final phone = (c['phone'] ?? '') as String?;
            final languages = ((c['languages'] as List?) ?? [])
                .map((e) => (e['name'] ?? '').toString())
                .where((s) => s.isNotEmpty)
                .toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              children: [
                // encabezado
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _brand.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(emoji ?? '', style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              )),
                          if (nativeName != null && nativeName.isNotEmpty)
                            Text('Nombre nativo: $nativeName',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.65),
                                  fontSize: 13.5,
                                )),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // tarjeta de pares clave-valor
                _CardSection(
                  child: Column(
                    children: [
                      _KVRow(label: 'Capital', value: capital),
                      const Divider(height: 16),
                      _KVRow(label: 'Continente', value: continentEs),
                      const Divider(height: 16),
                      _KVRow(
                        label: 'Moneda',
                        value: (currency != null && currency.isNotEmpty) ? currency : null,
                      ),
                      const Divider(height: 16),
                      _KVRow(
                        label: 'Código telefónico',
                        value: (phone != null && phone.isNotEmpty) ? '+$phone' : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // idiomas oficiales
                _CardSection(
                  title: 'Idiomas Oficiales',
                  child: languages.isEmpty
                      ? Text('—',
                          style: TextStyle(color: Colors.black.withOpacity(0.7)))
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: languages.map((lng) => _Chip(text: lng)).toList(),
                        ),
                ),

                const SizedBox(height: 16),

                // botón grande volver
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brand,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver a la Lista de Países'),
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

class _KVRow extends StatelessWidget {
  final String label;
  final String? value;
  const _KVRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final v = value;
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black.withOpacity(0.65),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            (v == null || v.isEmpty) ? '—' : v,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardSection extends StatelessWidget {
  final String? title;
  final Widget child;
  const _CardSection({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _brand.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: _brand.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _brand.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _brand.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.85),
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// traducción simple de continente
String _continentEs(String en) {
  switch (en) {
    case 'Europe':
      return 'Europa';
    case 'Asia':
      return 'Asia';
    case 'Africa':
      return 'Europa' == en ? 'Europa' : 'África';
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
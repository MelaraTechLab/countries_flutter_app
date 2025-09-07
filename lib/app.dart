import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/continents/presentation/pages/continents_page.dart';
import '../features/countries/presentation/pages/countries_by_continent_page.dart';
import '../features/country/presentation/pages/country_detail_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Countries GraphQL',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF3A5683),
        ),
        initialRoute: '/continents',
        onGenerateRoute: (settings) {
          if (settings.name == '/continents') {
            return MaterialPageRoute(builder: (_) => const ContinentsPage());
          }
          if (settings.name?.startsWith('/continents/') == true) {
            final code = settings.name!.split('/').last;
            return MaterialPageRoute(
              builder: (_) => CountriesByContinentPage(continentCode: code),
            );
          }
          if (settings.name?.startsWith('/country/') == true) {
            final code = settings.name!.split('/').last;
            return MaterialPageRoute(
              builder: (_) => CountryDetailPage(countryCode: code),
            );
          }
          return MaterialPageRoute(builder: (_) => const ContinentsPage());
        },
      ),
    );
  }
}

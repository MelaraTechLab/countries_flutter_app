import 'package:go_router/go_router.dart';
import '../features/continents/presentation/pages/continents_page.dart';
import '../features/countries/presentation/pages/countries_by_continent_page.dart';
import '../features/country/presentation/pages/country_detail_page.dart';

GoRouter buildRouter() => GoRouter(
  initialLocation: '/continents',
  routes: [
    GoRoute(path: '/continents', builder: (_, __) => const ContinentsPage()),
    GoRoute(
      path: '/continents/:code',
      builder: (ctx, st) => CountriesByContinentPage(
        continentCode: st.pathParameters['code']!,
      ),
    ),
    GoRoute(
      path: '/country/:code',
      builder: (ctx, st) => CountryDetailPage(
        countryCode: st.pathParameters['code']!,
      ),
    ),
  ],
);
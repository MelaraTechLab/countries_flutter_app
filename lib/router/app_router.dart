import 'package:go_router/go_router.dart';
import '../features/countries/presentation/pages/countries_page.dart';

GoRouter buildRouter() => GoRouter(
  initialLocation: '/countries',
  routes: [
    GoRoute(path: '/countries', builder: (_, __) => const CountriesPage()),
  ],
);
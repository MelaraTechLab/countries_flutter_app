import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Countries GraphQL',
        routerConfig: buildRouter(),
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF3A5683),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FooterNav extends StatelessWidget {
  const FooterNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            tooltip: 'Home',
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/continents'),
          ),
        ],
      ),
    );
  }
}
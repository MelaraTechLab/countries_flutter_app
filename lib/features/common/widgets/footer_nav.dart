import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _brand = Color(0xFF3A5683);

class FooterNav extends StatelessWidget {
  const FooterNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: _brand,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Center(
            child: InkWell(
              onTap: () => context.go('/continents'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.home, color: Colors.white),
                    SizedBox(height: 2),
                    Text('Inicio',
                        style: TextStyle(color: Colors.white, fontSize: 12.5)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
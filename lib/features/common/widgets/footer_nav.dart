import 'package:flutter/material.dart';

const _brand = Color(0xFF3A5683);

class FooterNav extends StatelessWidget {
  const FooterNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: _brand,
      elevation: 4,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Center(
            child: IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/continents', (route) => false);
              },
              icon: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 50,
              ),
              splashRadius: 28,
              tooltip: 'Inicio',
            ),
          ),
        ),
      ),
    );
  }
}

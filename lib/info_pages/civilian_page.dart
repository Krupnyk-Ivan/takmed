// civilian_page.dart
import 'package:flutter/material.dart';

class CivilianPage extends StatelessWidget {
  const CivilianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок "Цивільним"
            const Text(
              'Цивільним',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Картка "Зупинити кровотечу"
            _buildCard(
              context,
              title: 'Зупинити кровотечу',
              description:
                  'Міжнародний протокол STOP THE BLEED навчає виконувати лише 3 прості дії для зупинки важких кровотеч',
            ),
            const SizedBox(height: 10),

            // Картка "UniTactics"
            _buildCard(
              context,
              title: 'UniTactics',
              description:
                  'Практична перша BLS для цивільних умо та базового вишкольного протоколу, необхідні для допомоги при пораненнях',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

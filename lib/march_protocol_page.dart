import 'package:flutter/material.dart';

class MarchProtocolPage extends StatelessWidget {
  const MarchProtocolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Stack(
          children: [
            Center(
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Tak!',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: 'Med',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MARCH Protocol',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildProtocolCard(
              'M',
              'Масивна кровотеча',
              Icons.bloodtype,
              Colors.red,
              context,
              () {
                Navigator.pushNamed(context, '/testvideo');
              },
            ),
            const SizedBox(height: 10),
            _buildProtocolCard(
              'A',
              'Прохідність дихальних шляхів',
              Icons.airline_seat_individual_suite,
              Colors.green,
              context,
              null, // No navigation for this item
            ),
            const SizedBox(height: 10),
            _buildProtocolCard(
              'R',
              'Дихання',
              Icons.local_hospital,
              Colors.blue,
              context,
              null, // No navigation for this item
            ),
            const SizedBox(height: 10),
            _buildProtocolCard(
              'C',
              'Кровообіг',
              Icons.favorite,
              Colors.pink,
              context,
              null, // No navigation for this item
            ),
            const SizedBox(height: 10),
            _buildProtocolCard(
              'H',
              'Гіпотермія',
              Icons.ac_unit,
              Colors.cyan,
              context,
              null, // No navigation for this item
            ),
            const SizedBox(height: 10),
            _buildProtocolCard(
              '',
              'Діагностика ушкоджень',
              Icons.healing,
              Colors.orange,
              context,
              null, // No navigation for this item
            ),
            const SizedBox(height: 10),
            _buildProtocolCard(
              '',
              'Комунікація',
              Icons.message,
              Colors.purple,
              context,
              null, // No navigation for this item
            ),
            const SizedBox(height: 10),
            _buildProtocolCard(
              '',
              'Запис нової інформації',
              Icons.note_add,
              Colors.teal,
              context,
              null, // No navigation for this item
            ),
            const SizedBox(height: 10),
            _buildProtocolCard(
              '',
              'Платформа до евакуації',
              Icons.directions,
              Colors.amber,
              context,
              null, // No navigation for this item
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolCard(
    String code,
    String title,
    IconData icon,
    Color iconColor,
    BuildContext context, // Added BuildContext as a parameter
    VoidCallback? onTap, // Optional onTap callback
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  code.isNotEmpty ? '$code) $title' : title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

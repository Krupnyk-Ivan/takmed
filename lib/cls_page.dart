// cls_page.dart
import 'package:flutter/material.dart';

class CLSPage extends StatefulWidget {
  const CLSPage({super.key});

  @override
  State<CLSPage> createState() => _CLSPageState();
}

class _CLSPageState extends State<CLSPage> {
  bool _switchValue = false;
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
            // Перемикач
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Приховати спільнее 3 ACM',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Кнопки
            // Показуємо кнопки залежно від стану перемикача
            if (_switchValue) ...[
              // Якщо перемикач увімкнений (приховати співле 3 АЗМ)
              _buildButton(
                icon: Icons.air,
                iconColor: Colors.blue,
                text: '(R) Дихання',
              ),
              _buildButton(text: 'PAWS'),
              _buildButton(text: 'Другорядні ушкодження'),
            ] else ...[
              // Якщо перемикач вимкнений (показати всі кнопки)
              _buildButton(
                icon: Icons.bloodtype,
                iconColor: Colors.red,
                text: '(M) Масивна кровотеча',
              ),
              _buildButton(
                icon: Icons.air,
                iconColor: Colors.blue,
                text: '(A) Прохідність дихальних шляхів',
              ),
              _buildButton(
                icon: Icons.air,
                iconColor: Colors.blue,
                text: '(R) Дихання',
              ),
              _buildButton(
                icon: Icons.favorite,
                iconColor: Colors.red,
                text: '(C) Кровообіг',
              ),
              _buildButton(
                icon: Icons.ac_unit,
                iconColor: Colors.blue,
                text: '(H) Гіпотермія',
              ),
              _buildButton(text: 'PAWS'),

              _buildButton(text: 'Другорядні ушкодження'),
              _buildButton(text: 'Комунікації'),
              _buildButton(text: 'Заніс нової допомоги'),
              _buildButton(text: 'Підготовка до евакуації'),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Тест'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профіль'),
        ],
        currentIndex: 0, // "Головна" активна
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/test');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget _buildButton({
    IconData? icon,
    Color? iconColor,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

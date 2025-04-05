import 'package:flutter/material.dart';
import 'military_page.dart';
import 'march_protocol_page.dart';
import 'cls_page.dart';
import 'profile_page.dart';
import 'test_screen.dart';
import 'civilian_page.dart';
import 'FirstAidScreen.dart';
import 'video_screen_widget.dart';
import 'choose_test_page.dart';
import 'Logic/delete_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Delete the database on app start (useful for testing)
  await deleteDatabaseFile();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tak!Med',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 8, 8, 8),
        ),
      ),
      home: const MyHomePage(title: 'Tak!Med'),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const MyHomePage(title: 'Tak!Med'),
        '/military': (context) => const MilitaryPage(),
        '/march': (context) => const MarchProtocolPage(),
        '/cls': (context) => const CLSPage(),
        '/profile': (context) => const ProfilePage(),
        '/test': (context) => const ChooseTestPage(),
        '/civilian': (context) => const CivilianPage(),
        '/aid': (context) => const FirstAidScreen(),
        '/choose_test': (context) => const ChooseTestPage(),
        '/test_runner': (context) => const TestScreen(category: 'CLS'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Список сторінок для вкладок
  final List<Widget> _pages = [
    const HomeContent(), // Головна
    const ChooseTestPage(), // Тест
    const ProfilePage(), // Профіль
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Вимикаємо стрілку назад
        title: Center(
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
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
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
}

// Новий віджет для вмісту вкладки "Головна"
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле пошуку
            TextField(
              decoration: InputDecoration(
                hintText: 'Пошук терміна або матеріалу',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/military');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity, // Кнопка займає всю ширину
                    child: Center(
                      child: Text(
                        'Для військових',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Вертикальний відступ між кнопками
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/civilian',
                    ); // Навігація на сторінку "Цивільним"
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity, // Кнопка займає всю ширину
                    child: Center(
                      child: Text(
                        'Для цивільних',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 180),

            Container(
              width: double.infinity, // 32 (зовнішній) + 20 (внутрішній)

              height:
                  MediaQuery.of(context).size.width -
                  32, // Адаптивна висота, щоб відповідати ширині

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Image.asset(
                  'assets/rusoriz.png',
                  fit: BoxFit.contain,
                  width: double.infinity, // 32 (зовнішній) + 20 (внутрішній)
                  height:
                      MediaQuery.of(context).size.width -
                      52, // 32 (зовнішній) + 20 (внутрішній)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

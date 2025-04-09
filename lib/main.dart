import 'package:flutter/material.dart';
import 'info_pages/military_page.dart';
import 'info_pages/civilian_page.dart';
import 'profile_page.dart';
import 'test_pages/choose_test_page.dart';
import 'test_pages/test_screen.dart';
import 'medicine_pages/FirstAidScreen.dart';
import 'medicine_pages/add_medicine_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  runApp(const MyApp());
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
      locale: const Locale('uk', 'UA'),
      supportedLocales: const [Locale('en', 'US'), Locale('uk', 'UA')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Tak!Med'),
        '/test': (context) => const ChooseTestPage(),
        '/profile': (context) => const ProfilePage(),
        '/test_runner': (context) => const TestScreen(category: 'CLS'),
        '/aid': (context) => const FirstAidScreen(),
        '/add_medicine': (context) => const AddMedicineScreen(),
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
  int _homeContentSection = 0;

  // This list needs to be updated dynamically to access the updated HomeContent widget
  List<Widget> get _pages {
    return [
      HomeContent(
        selectedSection: _homeContentSection,
        onSectionChanged: (section) {
          setState(() {
            _homeContentSection = section;
          });
        },
      ),
      const ChooseTestPage(),
      const ProfilePage(),
    ];
  }

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
        leading:
            (_selectedIndex == 0 && _homeContentSection != 0)
                ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _homeContentSection = 0;
                    });
                  },
                )
                : null,
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
      body:
          _selectedIndex == 0
              ? HomeContent(
                selectedSection: _homeContentSection,
                onSectionChanged: (section) {
                  setState(() {
                    _homeContentSection = section;
                  });
                },
              )
              : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Тест'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профіль'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final int selectedSection;
  final Function(int) onSectionChanged;

  const HomeContent({
    super.key,
    required this.selectedSection,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: selectedSection,
            children: [
              _buildMainMenu(context),
              const MilitaryPage(),
              const CivilianPage(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
          ElevatedButton(
            onPressed: () => onSectionChanged(1),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Для військових',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => onSectionChanged(2),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Для цивільних',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          // Rest of the UI remains the same
          const SizedBox(height: 180),
          Image.asset(
            'assets/rusoriz.png',
            fit: BoxFit.contain,
            width: double.infinity,
            height: MediaQuery.of(context).size.width - 52,
          ),
        ],
      ),
    );
  }
}

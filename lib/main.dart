import 'package:flutter/material.dart';
import 'info_pages/military_page.dart';
import 'info_pages/civilian_page.dart';
import 'profile_page.dart';
import 'test_pages/choose_test_page.dart';
import 'test_pages/test_screen.dart';
import 'medicine_pages/first_aid_screen.dart';
import 'medicine_pages/add_medicine_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import './info_pages/march_protocol_page.dart';
import './info_pages/cls_page.dart';
import 'package:provider/provider.dart';
import 'app_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  runApp(
    ChangeNotifierProvider(create: (_) => AppNavigator(), child: const MyApp()),
  );
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
      home: MyHomePage(title: 'Tak!Med'),
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHomePage(title: 'Tak!Med'),
        '/military': (context) => const MilitaryPage(),
        '/march': (context) => const MarchProtocolPage(),
        '/cls': (context) => const CLSPage(),
        '/profile': (context) => const ProfilePage(),
        '/test': (context) => const ChooseTestPage(),
        '/civilian': (context) => const CivilianPage(),
        '/aid': (context) => const FirstAidScreen(),
        '/choose_test': (context) => const ChooseTestPage(),
        '/test_runner': (context) => const TestScreen(category: 'CLS'),
        '/add_medicine': (context) => const AddMedicineScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final appNav = Provider.of<AppNavigator>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading:
            appNav.currentPage != appNav.bottomNavPages[appNav.bottomNavIndex]
                ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    final appNav = Provider.of<AppNavigator>(
                      context,
                      listen: false,
                    );
                    appNav.goBack();
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
      body: appNav.currentPage, // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appNav.bottomNavIndex,
        onTap: (index) {
          appNav.selectBottomNavTab(index);
        },
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Тест'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профіль'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final infoNav = Provider.of<AppNavigator>(context);
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
                    final appNav = Provider.of<AppNavigator>(
                      context,
                      listen: false,
                    );
                    appNav.navigateTo(const MilitaryPage());
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
                    final appNav = Provider.of<AppNavigator>(
                      context,
                      listen: false,
                    );
                    appNav.navigateTo(const CivilianPage());
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

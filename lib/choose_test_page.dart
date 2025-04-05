import 'package:flutter/material.dart';
import './Logic/test_database_helper.dart';
import './Logic/test.dart';
import 'test_screen.dart';

class ChooseTestPage extends StatefulWidget {
  const ChooseTestPage({super.key});

  @override
  State<ChooseTestPage> createState() => _ChooseTestPageState();
}

class _ChooseTestPageState extends State<ChooseTestPage> {
  late Future<List<Test>> _testsFuture;

  @override
  void initState() {
    super.initState();
    _testsFuture = TestDatabaseHelper().getAllTests(); // Fetch tests from DB
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        flexibleSpace: Center(
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
      body: FutureBuilder<List<Test>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Loading state
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            ); // Error state
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tests available.'),
            ); // No tests state
          }

          final tests = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Виберіть тест',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Loop through tests and display each one in a styled card
                ...tests.map(
                  (test) => Container(
                    width: double.infinity, // Set the container width to full
                    height: 100, // Fixed height for the button
                    margin: const EdgeInsets.only(
                      bottom: 16.0,
                    ), // Space between buttons
                    child: Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => TestScreen(
                                    category:
                                        test.title, // Pass test title as category
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                test.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Тест'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профіль'),
        ],
        currentIndex: 1, // "Головна" is active
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}

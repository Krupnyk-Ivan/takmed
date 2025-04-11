import 'package:flutter/material.dart';
import '../database/test_db/test_database_helper.dart';
import '../database/test_db/test.dart';
import 'test_screen.dart';
import 'package:provider/provider.dart';
import '../app_navigator.dart';

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
    final appNav = Provider.of<AppNavigator>(context, listen: false);

    return Scaffold(
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Виберіть тест',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items in a row
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio:
                          1.8, // Width / Height ratio (change to affect height)
                    ),
                    itemCount: tests.length,
                    itemBuilder: (context, index) {
                      final test = tests[index];
                      return InkWell(
                        onTap: () {
                          appNav.navigateTo(TestScreen(category: test.title));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                test.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

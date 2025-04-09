import 'package:flutter/material.dart';
import '../database/medicine_db/medicine_database_helper.dart';
import '../database/medicine_db/medicine.dart'; // Your medicine model
import 'first_aid_category_screen.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  _FirstAidScreenState createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  late Future<List<Medicine>> _hemostaticAgents;
  late Future<List<Medicine>> _painRelievers;
  late Future<List<Medicine>> _bandages;
  late Future<List<Medicine>> _medications;

  @override
  void initState() {
    super.initState();
    _hemostaticAgents = MedicineDatabaseHelper().getMedicinesByCategory(
      "Кровоспинні",
    );
    _painRelievers = MedicineDatabaseHelper().getMedicinesByCategory(
      "Знеболюючі",
    );
    _bandages = MedicineDatabaseHelper().getMedicinesByCategory(
      "Бинти та шини",
    );
    _medications = MedicineDatabaseHelper().getMedicinesByCategory("Ліки");
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _categoryCard(
                    context,
                    Icons.bloodtype,
                    "Кропоспинні",
                    _hemostaticAgents,
                  ),
                  _categoryCard(
                    context,
                    Icons.favorite,
                    "Знеболюючі",
                    _painRelievers,
                  ),
                  _categoryCard(
                    context,
                    Icons.layers,
                    "Бинти та шини",
                    _bandages,
                  ),
                  _categoryCard(
                    context,
                    Icons.medical_services,
                    "Ліки",
                    _medications,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_medicine');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add new medicine",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _categoryCard(
    BuildContext context,
    IconData icon,
    String title,
    Future<List<Medicine>> medicines,
  ) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          _showMedicinesForCategory(context, title, medicines);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.black),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMedicinesForCategory(
    BuildContext context, // First argument should be BuildContext
    String category, // Second argument is the category (String)
    Future<List<Medicine>> medicines,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FirstAidCategoryScreen(category: category),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/test');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Tests"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../database/medicine_db/medicine_database_helper.dart';
import '../database/medicine_db/medicine.dart'; // Your medicine model
import 'first_aid_category_screen.dart';
import '../app_navigator.dart';
import 'package:provider/provider.dart';
import 'add_medicine_screen.dart';

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
    final appNav = Provider.of<AppNavigator>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Категорії",
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
                    "Кровоспинні",
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
                  appNav.navigateTo(const AddMedicineScreen());
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
    BuildContext context,
    String category,
    Future<List<Medicine>> medicines,
  ) {
    final appNav = Provider.of<AppNavigator>(context, listen: false);
    appNav.navigateTo(FirstAidCategoryScreen(category: category));
  }
}

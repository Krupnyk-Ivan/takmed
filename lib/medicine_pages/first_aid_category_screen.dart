import 'package:flutter/material.dart';
import '../database/medicine_db/medicine_database_helper.dart';
import '../database/medicine_db/medicine.dart'; // Your medicine model

class FirstAidCategoryScreen extends StatefulWidget {
  final String category;
  final MedicineDatabaseHelper? dbHelper; // Allow injecting a helper

  const FirstAidCategoryScreen({
    super.key,
    required this.category,
    this.dbHelper, // Accept injected helper
  });

  @override
  _FirstAidCategoryScreenState createState() => _FirstAidCategoryScreenState();
}

class _FirstAidCategoryScreenState extends State<FirstAidCategoryScreen> {
  late Future<List<Medicine>> medicines;
  late MedicineDatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    // Fetch medicines based on the passed category
    _dbHelper = widget.dbHelper ?? MedicineDatabaseHelper();

    // Fetch medicines based on the passed category using the selected dbHelper
    medicines = _dbHelper.getMedicinesByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Medicine>>(
        future: medicines,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Немає медицину в цій категорії.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final List<Medicine> medicineList = snapshot.data!;
          return ListView.builder(
            itemCount: medicineList.length,
            itemBuilder: (context, index) {
              final medicine = medicineList[index];
              return ListTile(
                tileColor:
                    medicine.isDangerous ? Colors.red.withOpacity(0.1) : null,
                leading: Icon(
                  IconData(medicine.iconCode, fontFamily: 'MaterialIcons'),
                  color: medicine.isDangerous ? Colors.red : null,
                ),
                title: Text(
                  medicine.name,
                  style: TextStyle(
                    color: medicine.isDangerous ? Colors.red : null,
                    fontWeight: medicine.isDangerous ? FontWeight.bold : null,
                  ),
                ),
                subtitle: Text(
                  'Термін придатності: ${medicine.expirationDate.toLocal()}',
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () async {
                    await _dbHelper.deleteMedicine(medicine.id!);
                    setState(() {
                      medicines = _dbHelper.getMedicinesByCategory(
                        widget.category,
                      );
                    });
                  },
                ),
                onTap: () {
                  // TODO: Maybe show medicine details?
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../database/medicine_db/medicine_database_helper.dart';
import '../database/medicine_db/medicine.dart'; // Your medicine model

class FirstAidCategoryScreen extends StatefulWidget {
  final String category;

  const FirstAidCategoryScreen({super.key, required this.category});

  @override
  _FirstAidCategoryScreenState createState() => _FirstAidCategoryScreenState();
}

class _FirstAidCategoryScreenState extends State<FirstAidCategoryScreen> {
  late Future<List<Medicine>> medicines;

  @override
  void initState() {
    super.initState();
    // Fetch medicines based on the passed category
    medicines = MedicineDatabaseHelper().getMedicinesByCategory(
      widget.category,
    );
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
                leading: Icon(
                  IconData(medicine.iconCode, fontFamily: 'MaterialIcons'),
                ),
                title: Text(medicine.name),
                subtitle: Text(
                  'Термін придатності: ${medicine.expirationDate.toLocal()}',
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // Handle the tap, for example, navigate to medicine details page
                },
              );
            },
          );
        },
      ),
    );
  }
}

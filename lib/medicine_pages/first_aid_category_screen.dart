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
      bottomNavigationBar: _buildBottomNavigationBar(context),
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

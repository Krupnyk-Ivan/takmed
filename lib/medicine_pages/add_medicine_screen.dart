import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../database/medicine_db/medicine.dart';
import '../database/medicine_db/medicine_database_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import '../app_navigator.dart';
import 'package:provider/provider.dart';
import 'first_aid_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  IconData? _selectedIcon;
  DateTime? _expirationDate;
  String? _selectedCategory;
  bool _isDangerous = false;

  // Categories to choose from
  final List<String> _categories = [
    'Ліки',
    'Кровоспинні',
    'Знеболюючі',
    'Бинти та шини',
  ];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  // Select an expiration date
  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: Locale('uk', 'UA'),
    );
    if (picked != null && picked != _expirationDate)
      setState(() {
        _expirationDate = picked;
      });
  }

  // Save the medicine to the database and schedule a notification
  void _saveMedicine() async {
    final appNav = Provider.of<AppNavigator>(context, listen: false);

    final name = _nameController.text.trim();
    if (name.isEmpty ||
        _selectedIcon == null ||
        _expirationDate == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Заповніть всі поля")));
      return;
    }

    // Create the Medicine object
    final medicine = Medicine(
      name: name,
      iconCode: _selectedIcon!.codePoint,
      note: _noteController.text,
      expirationDate: _expirationDate!,
      category: _selectedCategory!,
      isDangerous: _isDangerous,
    );

    // Save the medicine to SQLite
    await MedicineDatabaseHelper().insertMedicine(medicine);

    // Schedule the notification for the expiration date
    _scheduleNotification(medicine);
    appNav.navigateTo(const FirstAidScreen());
  }

  Future<void> _scheduleNotification(Medicine medicine) async {
    final androidDetails = AndroidNotificationDetails(
      'medicine_channel',
      'Medicine Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    final platformDetails = NotificationDetails(android: androidDetails);

    final expirationDate = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(seconds: 10)); // Set 1 minute later

    await flutterLocalNotificationsPlugin.zonedSchedule(
      123123,
      'Термін придатності ліків!',
      'Ліки ${medicine.name} закінчуються ${DateFormat('yyyy-MM-dd').format(medicine.expirationDate)}.',
      expirationDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exact, // доданий параметр
      payload: 'default_payload',
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Medicine Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Назва ліків"),
            ),
            const SizedBox(height: 10),
            const Text("Виберіть зображення"),
            // Icon selection
            Wrap(
              spacing: 10,
              children:
                  [
                    Icons.medical_services,
                    Icons.bloodtype,
                    Icons.healing,
                    Icons.local_hospital,
                  ].map((icon) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _selectedIcon == icon
                                  ? Colors.black
                                  : Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(icon, color: Colors.white),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            const Text("Термін приданості"),
            // Expiration Date selection
            Row(
              children: [
                Text(
                  _expirationDate == null
                      ? "Виберіть дату"
                      : DateFormat('yyyy-MM-dd').format(_expirationDate!),
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectExpirationDate(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Виберіть категорію"),
            // Category selection dropdown
            DropdownButton<String>(
              value: _selectedCategory,
              hint: const Text("Виберіть категорію"),
              isExpanded: true,
              onChanged: (String? newCategory) {
                setState(() {
                  _selectedCategory = newCategory;
                });
              },
              items:
                  _categories
                      .map(
                        (category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
            ),
            CheckboxListTile(
              title: const Text("⚠️ Небезпечні ліки"),
              value: _isDangerous,
              onChanged: (value) {
                setState(() {
                  _isDangerous = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),

            // Optional note
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: "Примітка"),
              maxLines: 3,
            ),

            const SizedBox(height: 20),
            // Save button
            ElevatedButton(onPressed: _saveMedicine, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}

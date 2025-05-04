import 'package:flutter/material.dart';
import '../../app_navigator.dart';
import 'package:provider/provider.dart';
import '../medicine_pages/first_aid_screen.dart';
import 'stats_screen.dart';
import '../database/stats_db_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Профіль',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // **Avatar Block**
            Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Олексій Петров',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Військовий медик',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // **Profile Buttons Grid**
            _buildProfileButtonsGrid(context),
          ],
        ),
      ),
    );
  }

  // **Avatar Widget**
  Widget _buildAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Center(
        child: Icon(Icons.person, color: Colors.white, size: 40),
      ),
    );
  }

  // **Profile Buttons Grid**
  Widget _buildProfileButtonsGrid(BuildContext context) {
    final appNav = Provider.of<AppNavigator>(context, listen: false);
    final dbHelper = StatsDatabaseHelper();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildProfileButton(context, 'Анкета', () {
              Navigator.pushNamed(context, '/form');
            }),
            _buildProfileButton(context, 'Статистика', () {
              appNav.navigateTo(
                StatsScreen(dbHelper: dbHelper),
              ); // Remove 'const' if dbHelper isn't const
            }),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildProfileButton(context, 'Аптечка', () {
              appNav.navigateTo(const FirstAidScreen());
            }),
            _buildProfileButton(context, 'Донат', () {
              Navigator.pushNamed(context, '/donate');
            }),
          ],
        ),
      ],
    );
  }

  // **Profile Button Widget**
  Widget _buildProfileButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width:
          (MediaQuery.of(context).size.width - 42) /
          2, // Two equal blocks minus padding
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // **Bottom Navigation Bar**
}

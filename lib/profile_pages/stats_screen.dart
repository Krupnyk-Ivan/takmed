import 'package:flutter/material.dart';
import '../../database/stats_db_helper.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.dbHelper});
  final StatsDatabaseHelper dbHelper;
  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<Map<String, dynamic>> _stats = [];
  bool _loading = true;

  int _totalScore = 0;
  int _totalTime = 0;
  int _testCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats =
        await widget.dbHelper.getAllStats(); // <<< Use widget.dbHelper

    int totalScore = 0;
    int totalTime = 0;

    for (var stat in stats) {
      totalScore += stat['score'] as int;
      totalTime += stat['timeTaken'] as int;
    }

    setState(() {
      _stats = stats;
      _totalScore = totalScore;
      _totalTime = totalTime;
      _testCount = stats.length;
      _loading = false;
    });
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика тестів'),
        automaticallyImplyLeading: false,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildStatCard(
                              'Кількість тестів',
                              '$_testCount',
                              Icons.assignment,
                              Colors.blue,
                            ),
                            _buildStatCard(
                              'Загальний час',
                              '$_totalTime',
                              Icons.av_timer,
                              Colors.green,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildStatCard(
                              'Середній бал',
                              _testCount == 0
                                  ? '-'
                                  : (_totalScore ~/ _testCount).toString(),
                              Icons.bar_chart,
                              Colors.orange,
                            ),
                            _buildStatCard(
                              'Середній час',
                              _testCount == 0
                                  ? '-'
                                  : (_totalTime ~/ _testCount).toString() +
                                      ' сек',
                              Icons.timer,
                              Colors.purple,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Спроби:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        _stats.isEmpty
                            ? const Center(child: Text('Немає записів.'))
                            : ListView.builder(
                              itemCount: _stats.length,
                              itemBuilder: (context, index) {
                                final stat = _stats[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 12,
                                  ),
                                  child: ListTile(
                                    title: Text('Тест: ${stat['testId']}'),
                                    subtitle: Text(
                                      'Результат: ${stat['score']} балів\nЧас: ${stat['timeTaken']} сек',
                                    ),
                                    trailing: Text('#${stat['id']}'),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}

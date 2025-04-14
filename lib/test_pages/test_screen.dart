import 'package:flutter/material.dart';
import '../database/question_db/question_db_helper.dart';
import '../database/question_db/test_question.dart';
import 'package:provider/provider.dart';
import '../app_navigator.dart';
import '../database/stats_db_helper.dart';

class TestScreen extends StatefulWidget {
  final String category;

  const TestScreen({super.key, required this.category});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<TestQuestion> _questions = [];
  int _currentQuestion = 0;
  int? _selectedIndex;
  bool _answered = false;
  bool _loading = true;
  int _score = 0;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await QuestionDatabaseHelper().getQuestionsByCategory(
      widget.category,
    );
    setState(() {
      _questions = questions;
      _loading = false;
    });
  }

  void _checkAnswer(int index) {
    setState(() {
      _selectedIndex = index;
      _answered = true;

      if (index == _questions[_currentQuestion].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() async {
    final appNav = Provider.of<AppNavigator>(context, listen: false);

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedIndex = null;
        _answered = false;
      });
    } else {
      final duration = DateTime.now().difference(_startTime).inSeconds;

      // Save to stats DB
      await StatsDatabaseHelper().insertStat({
        'userId': 1, // Adjust if you have real users
        'testId': widget.category.hashCode,
        'score': _score,
        'timeTaken': duration,
      });

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Тест завершено'),
              content: Text(
                'Ви пройшли усі запитання.\n\n'
                'Результат: $_score з ${_questions.length}\n'
                'Час: $duration сек.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    appNav.goBack();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appNav = Provider.of<AppNavigator>(context, listen: false);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = _questions[_currentQuestion];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Питання ${_currentQuestion + 1}/${_questions.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              question.question,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...List.generate(question.options.length, (index) {
              final isCorrect = index == question.correctIndex;
              final isSelected = index == _selectedIndex;

              Color color = Colors.white;
              if (_answered) {
                if (isSelected && isCorrect) {
                  color = Colors.green.shade400;
                } else if (isSelected && !isCorrect) {
                  color = Colors.red.shade400;
                } else if (isCorrect) {
                  color = Colors.green.shade100;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: _answered ? null : () => _checkAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: color,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      question.options[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Далі',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

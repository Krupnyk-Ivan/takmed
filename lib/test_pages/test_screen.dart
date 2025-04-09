import 'package:flutter/material.dart';
import '../database/question_db/question_db_helper.dart';
import '../database/question_db/test_question.dart';

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

  @override
  void initState() {
    super.initState();
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
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedIndex = null;
        _answered = false;
      });
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Тест завершено'),
              content: const Text('Ви пройшли усі запитання.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // go back
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
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = _questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
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

import 'package:flutter/material.dart';
import './Logic/question_db_helper.dart';
import './Logic/test_question.dart';

class TestScreen extends StatefulWidget {
  final String category; // Add category as a parameter

  const TestScreen({
    super.key,
    required this.category,
  }); // Receive category from the constructor

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
    ); // Use the passed category
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
              title: const Text('Test Completed'),
              content: const Text('You have finished the test.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
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
      appBar: AppBar(title: const Text('Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestion + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              question.question,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              final isCorrect = index == question.correctIndex;
              final isSelected = index == _selectedIndex;

              Color? color;
              if (_answered) {
                if (isSelected && isCorrect) {
                  color = Colors.green;
                } else if (isSelected && !isCorrect) {
                  color = Colors.red;
                } else if (isCorrect) {
                  color = Colors.green.withOpacity(0.3);
                }
              }

              return Card(
                color: color,
                child: ListTile(
                  title: Text(question.options[index]),
                  onTap: _answered ? null : () => _checkAnswer(index),
                ),
              );
            }),
            const Spacer(),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: const Text('Next'),
              ),
          ],
        ),
      ),
    );
  }
}

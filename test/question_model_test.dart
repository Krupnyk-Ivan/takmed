import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/database/question_db/test_question.dart';

void main() {
  group('TestQuestion logic', () {
    final question = TestQuestion(
      id: 10,
      question: 'Що таке турнікет?',
      options: ['Медичний інструмент', 'Засіб транспорту', 'Вид бинта'],
      correctIndex: 0,
    );

    test('Correct answer is recognized', () {
      final selectedIndex = 0;
      final isCorrect = selectedIndex == question.correctIndex;

      expect(isCorrect, isTrue);
    });

    test('Incorrect answer is recognized', () {
      final selectedIndex = 2;
      final isCorrect = selectedIndex == question.correctIndex;

      expect(isCorrect, isFalse);
    });

    test('Options list is not empty and has at least 2 choices', () {
      expect(question.options.isNotEmpty, isTrue);
      expect(question.options.length >= 2, isTrue);
    });

    test('Correct index is within valid range of options', () {
      expect(
        question.correctIndex,
        inInclusiveRange(0, question.options.length - 1),
      );
    });

    test('Question text is not empty', () {
      expect(question.question.trim().isNotEmpty, isTrue);
    });
  });
}

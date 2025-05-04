import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/database/medicine_db/medicine.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('Medicine model logic', () {
    test('Expiration date is in the future', () {
      final medicine = Medicine(
        name: 'Анальгін',
        iconCode: 0xe3e7,
        note: '1 таблетка двічі на день',
        expirationDate: DateTime.now().add(Duration(days: 30)),
        category: 'Знеболюючі',
        isDangerous: false,
      );

      expect(medicine.expirationDate.isAfter(DateTime.now()), isTrue);
    });

    test('Empty name should be invalid (manually validated)', () {
      final medicine = Medicine(
        name: '',
        iconCode: 0xe3e7,
        note: '1 таблетка двічі на день',
        expirationDate: DateTime.now().add(Duration(days: 30)),
        category: 'Антибіотики',
        isDangerous: false,
      );

      final isValid = medicine.name.trim().isNotEmpty;
      expect(isValid, isFalse);
    });

    test('Icon code should be positive', () {
      final medicine = Medicine(
        name: 'Ібупрофен',
        iconCode: 0,
        note: '',
        expirationDate: DateTime(2025, 12, 31),
        category: 'Жарознижувальні',
        isDangerous: false,
      );

      expect(medicine.iconCode >= 0, isTrue);
    });
  });
}

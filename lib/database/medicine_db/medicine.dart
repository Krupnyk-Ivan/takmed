class Medicine {
  final int? id;
  final String name;
  final int iconCode;
  final String note;
  final DateTime expirationDate;
  final String category;
  final bool isDangerous;

  Medicine({
    this.id,
    required this.name,
    required this.iconCode,
    required this.note,
    required this.expirationDate,
    required this.category,
    required this.isDangerous,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'note': note,
      'expirationDate': expirationDate.toIso8601String(),
      'category': category,
      'isDangerous': isDangerous ? 1 : 0, // зберігаємо як int у SQLite
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      iconCode: map['iconCode'],
      note: map['note'],
      expirationDate: DateTime.parse(map['expirationDate']),
      category: map['category'],
      isDangerous: map['isDangerous'] == 1, // читаємо як bool
    );
  }
}

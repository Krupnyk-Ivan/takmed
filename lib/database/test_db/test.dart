class Test {
  final int id;
  final String title;
  final String route;

  Test({required this.id, required this.title, required this.route});

  factory Test.fromMap(Map<String, dynamic> json) =>
      Test(id: json['id'], title: json['title'], route: json['route']);

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'route': route};
}

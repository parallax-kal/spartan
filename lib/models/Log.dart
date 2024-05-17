class Log {
  final String? id;
  final String title;
  final String description;
  final DateTime createdAt;

  Log({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory Log.fromJson(Map<String, dynamic> data) {
    return Log(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      createdAt: data['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }
}

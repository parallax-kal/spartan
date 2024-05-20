import 'package:spartan/utils/sort.dart';

class ANotification implements HasCreatedAt {
  String? id;
  final String title;
  final String body;
  final String? image;
  @override
  final DateTime createdAt;
  final String priority;
  final String? token;

  ANotification({
    this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.priority,
    this.token,
    this.image,
  });

  factory ANotification.fromJson(Map<String, dynamic> json) {
    return ANotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      priority: json['priority'] ?? 'high',
      image: json['image'],
      createdAt: json['createdAt'].toDate(),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'image': image,
      'createdAt': createdAt,
      'token': token,
      'priority': priority,
    };
  }
}

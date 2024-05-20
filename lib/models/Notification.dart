class Notification {
  final String title;
  final String body;
  final String? image;
  final String? time;
  final String priority = 'high';
  final String token;

  Notification({
    required this.title,
    required this.body,
    required this.time,
    required this.token,
    this.image,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'],
      body: json['body'],
      image: json['image'],
      time: json['time'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'image': image,
      'time': time,
      'token': token,
    };
  }
}

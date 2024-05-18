class Tip {
  String title;
  String description;
  String? coverImage;

  Tip({required this.title, required this.description, this.coverImage});

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      description: json['description'],
      title: json['title'],
      coverImage: json['coverImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'coverImage': coverImage,
    };
  }
}

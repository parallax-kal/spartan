class Tip {
  String description;
  String? coverImage;

  Tip({required this.description, this.coverImage});

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      description: json['description'],
      coverImage: json['coverImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'coverImage': coverImage,
    };
  }
}

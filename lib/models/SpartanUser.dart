class SpartanUser {
  String id;
  String fullname;
  String email;
  String profile;
  List<String> tokens;
  bool terms;
  String country;
  List<UnReadMessage>? unReadMessages;
  bool? community;
  bool? isOnline;


  SpartanUser({
    required this.id,
    required this.fullname,
    required this.email,
    required this.profile,
    required this.tokens,
    required this.country,
    required this.terms,
    this.isOnline = false,
    this.community = false,
    this.unReadMessages = const [],
  });

  factory SpartanUser.fromJson(Map<String, dynamic> json) {
    return SpartanUser(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      profile: json['profile'],
      terms: json['terms'],
      country: json['country'],
      tokens: List<String>.from(json['tokens']),
      isOnline: json['isOnline'],
      community: json['community'],
      unReadMessages: List<UnReadMessage>.from(json['unReadMessages']?.map((x) => UnReadMessage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'profile': profile,
      'country': country,
      'terms': terms,
      'tokens': tokens,
      'isOnline': isOnline,
      'community': community,
      'unReadMessages': unReadMessages?.map((x) => x.toJson()).toList(),
    };
  }
}

class UnReadMessage {
  String roomId;
  int count;

  UnReadMessage({
    required this.roomId,
    required this.count,
  });

  factory UnReadMessage.fromJson(Map<String, dynamic> json) {
    return UnReadMessage(
      roomId: json['roomId'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'count': count,
    };
  }
}
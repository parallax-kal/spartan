class SpartanUser {
  String fullname;
  String email;
  String profile;
  List<String> tokens;
  String id;
  bool isOnline;
  String lastActive;
  List<UnReadMessage> unReadMessages;

  SpartanUser({
    required this.fullname,
    required this.email,
    required this.profile,
    required this.tokens,
    required this.id,
    required this.isOnline,
    required this.lastActive,
    this.unReadMessages = const [], // Fix: Corrected the field name to 'unReadMessages'.
  });

  factory SpartanUser.fromJson(Map<String, dynamic> json) {
    return SpartanUser(
      fullname: json['fullname'],
      email: json['email'],
      profile: json['profile'],
      tokens: List<String>.from(json['tokens']),
      id: json['id'],
      isOnline: json['isOnline'],
      lastActive: json['lastActive'],
      unReadMessages: List<UnReadMessage>.from(json['unReadMessages'].map((x) => UnReadMessage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'profile': profile,
      'tokens': tokens,
      'id': id,
      'isOnline': isOnline,
      'lastActive': lastActive,
      'unReadMessages': unReadMessages.map((x) => x.toJson()).toList(),
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
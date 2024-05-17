class SpartanUser {
  String id;
  String fullname;
  String email;
  String? profile;
  List<String> tokens;
  bool? terms;
  String? country;
  List<UnReadMessage>? unReadMessages;
  bool? community;
  bool? isOnline;
  bool? hasCribs;
  USERSTATUS status = USERSTATUS.ACTIVE;

  SpartanUser({
    required this.id,
    required this.fullname,
    required this.email,
    required this.tokens,
    this.status = USERSTATUS.ACTIVE,
    this.hasCribs,
    this.profile,
    this.country,
    this.terms,
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
      isOnline: json['isOnline'] ?? false,
      community: json['community'] ?? false,
      hasCribs: json['hasCribs'] ?? false,
      status: json['status'],
      unReadMessages: List<UnReadMessage>.from(
          json['unReadMessages']?.map((x) => UnReadMessage.fromJson(x))),
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
      'isOnline': isOnline ?? false,
      'community': community ?? false,
      'hasCribs': hasCribs ?? false,
      'status': status.name,
      'unReadMessages': unReadMessages?.map((x) => x.toJson()).toList(),
    };
  }

  SpartanUser copyWith({
    String? id,
    String? fullname,
    String? email,
    String? profile,
    List<String>? tokens,
    bool? terms,
    String? country,
    List<UnReadMessage>? unReadMessages,
    bool? community,
    bool? isOnline,
  }) {
    return SpartanUser(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      profile: profile ?? this.profile,
      tokens: tokens ?? this.tokens,
      terms: terms ?? this.terms,
      country: country ?? this.country,
      unReadMessages: unReadMessages ?? this.unReadMessages,
      community: community ?? this.community,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

enum USERSTATUS {
  DELETED,
  ACTIVE,
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

  static int getRoomUnReadMessages(
      String roomId, List<UnReadMessage>? unReadMessages) {
    return unReadMessages
            ?.firstWhere((element) => element.roomId == roomId)
            .count ??
        0;
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'count': count,
    };
  }
}

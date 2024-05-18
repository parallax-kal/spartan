// ignore_for_file: constant_identifier_names

import 'package:reaction_askany/models/emotions.dart';

class Message {
  String? id;
  String? message;
  Sender sender;
  MESSAGETYPE type;
  DateTime createdAt;
  String? replyMessage;
  List<EmotionReply> emotionReplies;
  MESSAGESTATUS status;

  Message({
    this.id,
    this.message,
    required this.sender,
    required this.type,
    this.replyMessage,
    this.emotionReplies = const [],
    this.status = MESSAGESTATUS.SENDING,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      sender: Sender.fromJson(json['sender']),
      type: MESSAGETYPE.values.firstWhere((e) => e.toString() == json['type']),
      replyMessage: json['replyMessage'],
      emotionReplies: (json['emotionReplies'] as List<dynamic>)
          .map((e) => EmotionReply.fromJson(e))
          .toList(),
      status: MESSAGESTATUS.values
          .firstWhere((e) => e.toString() == json['status']),
      createdAt: json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender.tojson(),
      'type': type.toString(),
      'replyMessage': replyMessage,
      'emotionReplies': emotionReplies.map((e) => e.toJson()).toList(),
      'status': status.toString(),
      'createdAt': createdAt,
    };
  }
}

class Sender {
  final String? profile;
  final String uid;

  const Sender({required this.uid, this.profile});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(uid: json['uid'], profile: json['profile']);
  }

  Map<String, dynamic> tojson() {
    return {
      'uid': uid,
      'profile': profile,
    };
  }
}

class EmotionReply {
  final String userId;
  final Emotions emotion;

  EmotionReply({
    required this.userId,
    required this.emotion,
  });

  factory EmotionReply.fromJson(Map<String, dynamic> json) {
    return EmotionReply(
      userId: json['userId'],
      emotion:
          Emotions.values.firstWhere((e) => e.toString() == json['emotion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'emotion': emotion.toString(),
    };
  }
}

enum MESSAGETYPE {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
  FILE,
}

enum MESSAGESTATUS {
  SENDING,
  SENT,
  RECEIVED,
  READ,
}

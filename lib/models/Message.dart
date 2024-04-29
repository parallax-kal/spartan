import 'package:reaction_askany/models/emotions.dart';

class Message {
  String message;
  String sendBy;
  MessageType type;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? fileUrl;
  String? location;
  DateTime createdAt;
  String? replyMessage;
  List<EmotionReply> emotionReplies;
  MessageStatus status;

  Message({
    required this.message,
    required this.sendBy,
    required this.type,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.fileUrl,
    this.location,
    this.replyMessage,
    this.emotionReplies = const [],
    this.status = MessageStatus.SENDING,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      sendBy: json['sendBy'],
      type: MessageType.values.firstWhere((e) => e.toString() == json['type']),
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      audioUrl: json['audioUrl'],
      fileUrl: json['fileUrl'],
      location: json['location'],
      replyMessage: json['replyMessage'],
      emotionReplies: (json['emotionReplies'] as List<dynamic>)
          .map((e) => EmotionReply.fromJson(e))
          .toList(),
      status: MessageStatus.values
          .firstWhere((e) => e.toString() == json['status']),
      createdAt: json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sendBy': sendBy,
      'type': type.toString(),
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'fileUrl': fileUrl,
      'location': location,
      'replyMessage': replyMessage,
      'emotionReplies': emotionReplies.map((e) => e.toJson()).toList(),
      'status': status.toString(),
      'createdAt': createdAt,
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

enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
  FILE,
  LOCATION,
}

enum MessageStatus {
  SENDING,
  SENT,
  RECEIVED,
  READ,
}

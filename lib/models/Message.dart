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
  DateTime timestamp;
  String? replyMessage;
  List<Emotions> emotions;
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
    this.emotions = const [],
    this.status = MessageStatus.SENDING,
    required this.timestamp,
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
      emotions: (json['emotions'] as List<dynamic>).map((x) => Emotions.values.firstWhere((e) => e.toString() == x)).toList(),
      status: MessageStatus.values.firstWhere((e) => e.toString() == json['status']),
      timestamp: json['timestamp'].toDate(),
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
      'emotions': emotions.map((e) => e.toString()).toList(),
      'status': status.toString(),
      'timestamp': timestamp,
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

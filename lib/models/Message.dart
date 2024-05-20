// ignore_for_file: constant_identifier_names
import 'package:spartan/utils/sort.dart';

class Message implements HasCreatedAt {
  String? id;
  String? message;
  Sender sender;
  MESSAGETYPE type;
  DateTime createdAt;
  MESSAGESTATUS status;

  Message({
    this.id,
    this.message,
    required this.sender,
    required this.type,
    this.status = MESSAGESTATUS.SENDING,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      sender: Sender.fromJson(json['sender']),
      type: MESSAGETYPE.values.firstWhere((e) => e.name == json['type']),
      status: MESSAGESTATUS.values
          .firstWhere((e) => e.name == json['status']),
      createdAt: json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender.tojson(),
      'type': type.name,
      'status': status.name,
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

enum MESSAGETYPE {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
}

enum MESSAGESTATUS {
  SENDING,
  SENT,
  RECEIVED,
  READ,
}

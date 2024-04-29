import 'package:spartan/models/Message.dart';
import 'package:spartan/models/SpartanUser.dart';

class Room {
  String id;
  String name;
  String profile;
  List<String> invitedIds;
  bool private;
  List<String> acceptedIds = [];
  DateTime lastMessageAt = DateTime.now();
  DateTime createdAt = DateTime.now();

  Room({
    required this.id,
    required this.name,
    required this.profile,
    required this.private,
    this.invitedIds = const [],
    this.acceptedIds = const [],
    required this.lastMessageAt,
    required this.createdAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      profile: json['profile'],
      invitedIds: List<String>.from(json['invitedIds']),
      acceptedIds: List<String>.from(json['acceptedIds']),
      private: json['private'],
      lastMessageAt: DateTime.parse(json['lastMessageAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile': profile,
      'invitedIds': invitedIds,
      'acceptedIds': acceptedIds,
      'private': private,
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class DisplayableRoom {
  final Room room;
  final SpartanUser user;
  final Message message;

  DisplayableRoom({
    required this.room,
    required this.user,
    required this.message,
  });

  LastMessage lastMessage() {
    if (message.sendBy == user.id) {
      if (room.id.contains(user.id)) {
        return LastMessage(
          unreadCount: 0,
          message: message.message,
          sendBy: message.sendBy,
          type: message.type,
          createdAt: message.createdAt,
          imageUrl: message.imageUrl,
          videoUrl: message.videoUrl,
          audioUrl: message.audioUrl,
          fileUrl: message.fileUrl,
          location: message.location,
          replyMessage: message.replyMessage,
          emotionReplies: message.emotionReplies,
          status: message.status,
        );
      } else {
        return LastMessage(
          unreadCount: 0,
          message: message.message,
          sendBy: message.sendBy,
          type: message.type,
          createdAt: message.createdAt,
          imageUrl: message.imageUrl,
          videoUrl: message.videoUrl,
          audioUrl: message.audioUrl,
          fileUrl: message.fileUrl,
          location: message.location,
          replyMessage: message.replyMessage,
          emotionReplies: message.emotionReplies,
          status: MessageStatus.SENT,
        );
      }
    } else {
      return LastMessage(
        unreadCount: user.unReadMessages
            .firstWhere((element) => element.roomId == room.id)
            .count,
        message: message.message,
        sendBy: message.sendBy,
        type: message.type,
        createdAt: message.createdAt,
        imageUrl: message.imageUrl,
        videoUrl: message.videoUrl,
        audioUrl: message.audioUrl,
        fileUrl: message.fileUrl,
        location: message.location,
        replyMessage: message.replyMessage,
        emotionReplies: message.emotionReplies,
        status: message.status,
      );
    }
  }
}

class LastMessage extends Message {
  final int unreadCount;

  LastMessage({
    required this.unreadCount,
    required super.message,
    required super.sendBy,
    required super.type,
    required super.createdAt,
    super.imageUrl,
    super.videoUrl,
    super.audioUrl,
    super.fileUrl,
    super.location,
    super.replyMessage,
    super.emotionReplies,
    required super.status,
  });
}

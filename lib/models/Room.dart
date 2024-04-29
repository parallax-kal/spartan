import 'package:reaction_askany/models/emotions.dart';
import 'package:spartan/models/Message.dart';
import 'package:spartan/models/SpartanUser.dart';

class Room {
  String id;
  String name;
  String profile;
  List<String> invitedIds;
  bool private;
  List<String> acceptedIds = [];

  Room({
    required this.id,
    required this.name,
    required this.profile,
    this.invitedIds = const [],
    this.acceptedIds = const [],
    required this.private,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      profile: json['profile'],
      invitedIds: List<String>.from(json['invitedIds']),
      acceptedIds: List<String>.from(json['acceptedIds']),
      private: json['private'],
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
          timestamp: message.timestamp,
          imageUrl: message.imageUrl,
          videoUrl: message.videoUrl,
          audioUrl: message.audioUrl,
          fileUrl: message.fileUrl,
          location: message.location,
          replyMessage: message.replyMessage,
          emotions: message.emotions,
          status: message.status,
        );
      } else {
        return LastMessage(
          unreadCount: 0,
          message: message.message,
          sendBy: message.sendBy,
          type: message.type,
          timestamp: message.timestamp,
          imageUrl: message.imageUrl,
          videoUrl: message.videoUrl,
          audioUrl: message.audioUrl,
          fileUrl: message.fileUrl,
          location: message.location,
          replyMessage: message.replyMessage,
          emotions: message.emotions,
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
        timestamp: message.timestamp,
        imageUrl: message.imageUrl,
        videoUrl: message.videoUrl,
        audioUrl: message.audioUrl,
        fileUrl: message.fileUrl,
        location: message.location,
        replyMessage: message.replyMessage,
        emotions: message.emotions,
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
    required super.timestamp,
    super.imageUrl,
    super.videoUrl,
    super.audioUrl,
    super.fileUrl,
    super.location,
    super.replyMessage,
    super.emotions,
    required super.status,
  });
}

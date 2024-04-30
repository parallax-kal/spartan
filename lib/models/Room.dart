import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Message.dart';
import 'package:spartan/models/SpartanUser.dart';

class Room {
  String id;
  String name;
  String profile;
  List<String> invitedIds;
  bool private;
  List<String> acceptedIds = [];
  Timestamp lastMessageAt = Timestamp.now();
  Timestamp createdAt = Timestamp.now();
  int totalMembers = 0;

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
      invitedIds: List<String>.from(json['invitedIds'] ?? []),
      acceptedIds: List<String>.from(json['acceptedIds'] ?? []),
      private: json['private'],
      lastMessageAt: json['lastMessageAt'],
      createdAt: json['createdAt'],
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
      'lastMessageAt': lastMessageAt,
      'createdAt': createdAt,
    };
  }

  Future getTotalMembers() async {
    if (id == 'spartan_global') {
      await firestore
          .collection('users')
          .where('community', isEqualTo: true)
          .get()
          .then((value) {
        totalMembers = value.docs.length;
      });
    } else {
      totalMembers = acceptedIds.length;
    }
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
        unreadCount: user.unReadMessages!
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

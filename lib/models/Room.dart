import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';

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

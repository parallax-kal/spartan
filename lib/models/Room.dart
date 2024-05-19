import 'package:spartan/constants/firebase.dart';

class Room {
  String? id;
  String name;
  String? profile;
  List<String> invitedIds;
  bool private;
  bool group;
  List<String> acceptedIds = [];
  DateTime createdAt;
  int totalMembers = 0;

  Room({
    required this.name,
    required this.createdAt,
    required this.private,
    required this.group,
    this.id,
    this.profile,
    this.invitedIds = const [],
    this.acceptedIds = const [],
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      profile: json['profile'],
      invitedIds: List<String>.from(json['invitedIds'] ?? []),
      acceptedIds: List<String>.from(json['acceptedIds'] ?? []),
      private: json['private'],
      group: json['group'],
      createdAt: json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profile': profile,
      'invitedIds': invitedIds,
      'acceptedIds': acceptedIds,
      'private': private,
      'group': group,
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

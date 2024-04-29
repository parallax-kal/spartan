import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Message.dart';
import 'package:spartan/models/Room.dart';

class ChatService {
  Future createRoom(Room room) {
    return firestore.collection('rooms').add({
      'name': room.name,
      'profile': room.profile,
      'users_ids': room.invitedIds,
      'private': room.private,
    });
  }

  Future<void> sendMessage(String roomId, Message message) async {
    await firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .add(message.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRooms() {
    // use auth.currentUser.uid to get the rooms of the current user
    return firestore
        .collection('rooms')
        .where(
          'acceptedIds',
          arrayContains: auth.currentUser!.uid,
        )
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String roomId) {
    return firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Message.dart';
import 'package:spartan/models/Room.dart';

class ChatService {
  static Future createRoom(Room room) {
    return firestore.collection('rooms').add({
      'name': room.name,
      'profile': room.profile,
      'users_ids': room.invitedIds,
      'private': room.private,
    });
  }

  static Future<void> sendMessage(String roomId, Message message) async {
    await firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .add(message.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getGlobalRoom() {
    return firestore
        .collection('rooms')
        .where('name', isEqualTo: 'Spartan_Global')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRooms() {
    // use auth.currentUser.uid to get the rooms of the current user
    return firestore
        .collection('rooms')
        .where(
          'invitedIds',
          arrayContains: auth.currentUser!.uid,
        )
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      String roomId) {
    return firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String roomId) {
    return firestore
        .collection('rooms/$roomId/messages/')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>>
      getUserStream() {
    return firestore.collection('users').doc(auth.currentUser!.uid).snapshots();
  }

}

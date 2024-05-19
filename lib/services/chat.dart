import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Message.dart';
import 'package:spartan/models/Room.dart';
import 'package:rxdart/rxdart.dart';

class ChatService {
  static Future createRoom(Room room) {
    return firestore.collection('rooms').add({
      'name': room.name,
      'profile': room.profile,
      'users_ids': room.invitedIds,
      'private': room.private,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getTips() {
    return firestore
        .collection('tips')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future sendMessage(String roomId, Message message) {
    return firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .add(message.toJson());
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getGlobalRoom() {
    return firestore.collection('rooms').doc('spartan_global').snapshots();
  }

  static Stream<List<Room>> getAllRooms() {
    return BehaviorSubject<void>.seeded(null).switchMap((_) {
      var globalRoom =
          firestore.collection('rooms').doc('spartan_global').snapshots();
      var userRooms = firestore
          .collection('rooms')
          .where('invitedIds', arrayContains: auth.currentUser!.uid)
          .snapshots();

      return CombineLatestStream.list([
        globalRoom,
        userRooms,
      ]).map((rooms) {
        var globalRoom = rooms[0] as DocumentSnapshot<Map<String, dynamic>>;
        var userRooms = rooms[1] as QuerySnapshot<Map<String, dynamic>>;

        List<Room> allRooms = [];
        allRooms.add(Room.fromJson({
          'id': globalRoom.id,
          ...globalRoom.data()!,
        }));

        allRooms.addAll(userRooms.docs.map((doc) {
          return Room.fromJson({
            'id': doc.id,
            ...doc.data(),
          });
        }));

        return allRooms;
      });
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRooms() {
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

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream() {
    return firestore.collection('users').doc(auth.currentUser!.uid).snapshots();
  }
}

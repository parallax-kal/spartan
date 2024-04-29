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

  Future<void> sendMessage(String roomId, Message message) {
    return firestore.collection('rooms').doc(roomId).collection('messages').add(
          message.toJson(),
        );
  }


}

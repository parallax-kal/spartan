import 'package:chatview3/chatview3.dart';
import 'package:spartan/constants/firebase.dart';

class ChatService {
  String getChatRoomId(String userId) {
    List<String> ids = [auth.currentUser!.uid, userId];
    ids.sort();
    return ids.join('-');
  }

  Future<void> sendChatMessage(Message message) async {
    await firestore
        .collection('rooms')
        .doc(message.id)
        .collection('messages')
        .add({
      'message': message.message,
      'sendBy': message.sendBy,
      'reply': message.replyMessage,
      'reaction': message.reaction,
      'voiceDuration': message.voiceMessageDuration,
      'messageType': message.messageType.toString(),
      'status': MessageStatus.delivered.toString(),
      'timestamp': message.createdAt,
    });
  }
}

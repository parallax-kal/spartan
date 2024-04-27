import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatview3/chatview3.dart';
import 'package:spartan/constants/firebase.dart';

class MessagesScreen extends StatefulWidget {
  final String room;
  const MessagesScreen({
    super.key,
    required this.room,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final currentUser = ChatUser(
    id: auth.currentUser!.uid,
    name: auth.currentUser!.displayName!,
    profilePhoto: auth.currentUser!.photoURL!,
  );

  final chatController = ChatController(
    scrollController: ScrollController(),
    initialMessageList: [],
    chatUsers: [],
  );
  Stream<QuerySnapshot>? messageStream;
  StreamSubscription<QuerySnapshot>? messageStreamSubscription;

  Stream<QuerySnapshot> getMessagesStream() {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.room)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
    return stream;
  }

  @override
  void initState() {
    super.initState();

    firestore.collection('users').get().then((value) {
      chatController.chatUsers =
          value.docs.map((e) => ChatUser.fromJson(e.data())).toList();
    });

    messageStream = getMessagesStream();
    messageStreamSubscription = messageStream!.listen((snapshots) {
      if (snapshots.docs.isNotEmpty) {
        chatController.initialMessageList = snapshots.docs
            .map((e) => Message.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void onSendTap(
      String message,
      ReplyMessage replyMessage,
      MessageType messageType,
    ) {
      chatController.addMessage(
        Message(
          id: widget.room,
          createdAt: DateTime.now(),
          message: message,
          sendBy: currentUser.id,
          replyMessage: replyMessage,
          messageType: messageType,
        ),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        chatController.initialMessageList.last.setStatus =
            MessageStatus.undelivered;
      });
      Future.delayed(const Duration(seconds: 1), () {
        chatController.initialMessageList.last.setStatus = MessageStatus.read;
      });
    }

    return Scaffold(
      body: ChatView2(
        chatController: chatController,
        onSendTap: onSendTap,
        currentUser: currentUser,
        chatview2State: ChatView2State.noData,
        featureActiveConfig: const FeatureActiveConfig(
          lastSeenAgoBuilderVisibility: true,
          receiptsBuilderVisibility: true,
        ),
        chatview2StateConfig: Chatview2StateConfiguration(
          loadingWidgetConfig: const ChatView2StateWidgetConfiguration(
            loadingIndicatorColor: Colors.red,
          ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: const TypeIndicatorConfiguration(
          flashingCircleBrightColor: Colors.blue,
          flashingCircleDarkColor: Colors.red,
        ),
      ),
    );
  }
}

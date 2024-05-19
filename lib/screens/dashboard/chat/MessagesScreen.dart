import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Message.dart';
import 'package:spartan/notifiers/CurrentRoomNotifier.dart';
import 'package:spartan/services/chat.dart';
import 'package:chat_composer/chat_composer.dart';
import 'package:spartan/services/toast.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:image_picker/image_picker.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  TextEditingController chatTextController = TextEditingController();

  final ScrollController _messageScrollController = ScrollController();

  @override
  void dispose() {
    _messageScrollController.dispose();
    super.dispose();
  }

  List<Map<DateTime, List<Message>>> sortMessages(List<Message> messages) {
    Map<DateTime, List<Message>> sortedMessages = {};

    for (Message message in messages) {
      DateTime messageDate = message.createdAt;
      DateTime messageDay =
          DateTime(messageDate.year, messageDate.month, messageDate.day);

      if (sortedMessages.containsKey(messageDay)) {
        sortedMessages[messageDay]!.add(message);
      } else {
        sortedMessages[messageDay] = [message];
      }
    }

    List<Map<DateTime, List<Message>>> sortedList = [];

    sortedMessages.forEach((key, value) {
      sortedList.add({key: value});
    });

    return sortedList;
  }

  MESSAGETYPE checkFileType(String extension) {
    if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
      return MESSAGETYPE.IMAGE;
    } else if (['mp4', 'mkv', 'avi', 'mov'].contains(extension)) {
      return MESSAGETYPE.VIDEO;
    } else if (['mp3', 'acc', 'wav'].contains(extension)) {
      return MESSAGETYPE.AUDIO;
    } else {
      return MESSAGETYPE.TEXT;
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentRoomNotifier currentRoomNotifier =
        Provider.of<CurrentRoomNotifier>(context, listen: true);
    ToastService toastService = ToastService(context);
    ImagePicker picker = ImagePicker();

    return Scaffold(
      backgroundColor: const Color(0XFFF2F2F2),
      appBar: AppBar(
        leadingWidth: 30,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: currentRoomNotifier.currentRoom!.profile == null
                  ? null
                  : NetworkImage(currentRoomNotifier.currentRoom!.profile!),
              child: currentRoomNotifier.currentRoom!.profile == null
                  ? currentRoomNotifier.currentRoom!.id == 'spartan_global'
                      ? Image.asset(
                          'assets/images/logo.png',
                          width: 30,
                        )
                      : const Icon(
                          Icons.group,
                          color: Colors.black,
                        )
                  : null,
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentRoomNotifier.currentRoom!.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${currentRoomNotifier.currentRoom!.totalMembers} Members',
                  style: const TextStyle(
                    color: Color(0XFF707070),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: () {},
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  ChatService.getMessages(currentRoomNotifier.currentRoom!.id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    List<Message>? messages = snapshot.data?.docs
                        .map((e) => Message.fromJson({
                              'id': e.id,
                              ...e.data(),
                            }))
                        .toList();

                    if (messages == null || messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'Say Hii! 👋',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }

                    List<Map<DateTime, List<Message>>> sortedMessages =
                        sortMessages(messages);

                    return SingleChildScrollView(
                      controller: _messageScrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: sortedMessages.map(
                          (sortedMessage) {
                            DateTime wholeday = sortedMessage.keys.first;
                            List<Message> messages = sortedMessage.values.first;

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      DateFormat(
                                              'd MMM${wholeday.year != DateTime.now().year ? ' yyyy' : ''}')
                                          .format(wholeday),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  children: messages.map((message) {
                                    return Column(
                                      children: [
                                        ChatBubble(
                                          message: message.message!,
                                          isSender: message.sender.uid ==
                                              auth.currentUser!.uid,
                                          createdAt: message.createdAt,
                                          profile: message.sender.profile,
                                          type: message.type,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    );
                }
              },
            ),
          ),
          ChatComposer(
            controller: chatTextController,
            onReceiveText: (str) async {
              try {
                Message message = Message(
                  message: str!,
                  sender: Sender(
                    uid: auth.currentUser!.uid,
                    profile: auth.currentUser!.photoURL!,
                  ),
                  type: MESSAGETYPE.TEXT,
                  createdAt: DateTime.now(),
                );
                await ChatService.sendMessage(
                  currentRoomNotifier.currentRoom!.id,
                  message,
                );
                chatTextController.text = '';
              } catch (error) {
                String errorMessage = displayErrorMessage(error);
                toastService.showErrorToast(errorMessage);
              }
            },
            composerColor: const Color.fromRGBO(217, 217, 217, 0.38),
            backgroundColor: Colors.white,
            sendButtonBackgroundColor: const Color(0xFF235380),
            onRecordEnd: (path) async {
              if (path != null) {
                try {
                  File file = File(path);
                  String filename =
                      'messages/voice_note/voice_note_${DateTime.now().microsecondsSinceEpoch}.acc';
                  await storage.ref(filename).putFile(file);
                  String url = await storage.ref(filename).getDownloadURL();
                  Message message = Message(
                    message: url,
                    sender: Sender(
                      uid: auth.currentUser!.uid,
                      profile: auth.currentUser!.photoURL!,
                    ),
                    type: MESSAGETYPE.AUDIO,
                    createdAt: DateTime.now(),
                  );
                  await ChatService.sendMessage(
                    currentRoomNotifier.currentRoom!.id,
                    message,
                  );
                } catch (error) {
                  String errorMessage = displayErrorMessage(error);
                  toastService.showErrorToast(errorMessage);
                }
              }
            },
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.attach_file,
                  color: Color(0xFF7B7B7B),
                ),
                onPressed: () async {
                  List<XFile> images = await picker.pickMultiImage();
                  if (images.isEmpty) {
                    return;
                  }

                  List<File> files =
                      images.map((image) => File(image.path)).toList();
                  for (File file in files) {
                    try {
                      MESSAGETYPE type = checkFileType(file.path);
                      String filename =
                          'messages/${type.name.toLowerCase()}/${DateTime.now().microsecondsSinceEpoch}_${file.path.split('/').last}';
                      await storage.ref(filename).putFile(file);
                      String url = await storage.ref(filename).getDownloadURL();
                      Message message = Message(
                        message: url,
                        sender: Sender(
                          uid: auth.currentUser!.uid,
                          profile: auth.currentUser!.photoURL!,
                        ),
                        type: type,
                        createdAt: DateTime.now(),
                      );
                      await ChatService.sendMessage(
                        currentRoomNotifier.currentRoom!.id,
                        message,
                      );
                    } catch (error) {
                      String errorMessage = displayErrorMessage(error);
                      toastService.showErrorToast(errorMessage);
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;
  final String? profile;
  final DateTime createdAt;
  final MESSAGETYPE type;
  const ChatBubble({
    super.key,
    required this.isSender,
    required this.message,
    required this.createdAt,
    required this.type,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender)
          const SizedBox(
            width: 20,
          ),
        if (isSender)
          Text(
            DateFormat('h:mm a').format(createdAt),
            style: const TextStyle(
              color: Color(0XFF444444),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (!isSender)
          if (profile != null)
            CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(profile!),
            ),
        if (profile == null)
          const CircleAvatar(
            child: Icon(Icons.person),
          ),
        if (isSender) const SizedBox(width: 10),
        MessageRender(message: message, type: type, isSender: isSender),
        if (!isSender) const SizedBox(width: 10),
        if (!isSender)
          Text(
            DateFormat('h:mm a').format(createdAt),
            style: const TextStyle(
              color: Color(0XFF444444),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (isSender)
          const SizedBox(
            width: 30,
          )
      ],
    );
  }
}

class MessageRender extends StatelessWidget {
  final String message;
  final MESSAGETYPE type;
  final bool isSender;

  MessageRender({
    required this.message,
    required this.type,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return type == MESSAGETYPE.AUDIO
        ? VoiceMessageView(
            circlesColor: const Color(0xFF235380),
            activeSliderColor: const Color(0xFF235380),
            controller: VoiceController(
              audioSrc: message,
              onComplete: () {
                return;
              },
              onPause: () {
                return;
              },
              onPlaying: () {
                return;
              },
              onError: (err) {
                String errorMessage = displayErrorMessage(err);
                ToastService(context).showErrorToast(errorMessage);
              },
              maxDuration: const Duration(minutes: 2),
              isFile: false,
            ),
            innerPadding: 12,
            cornerRadius: 20,
          )
        : type == MESSAGETYPE.IMAGE
            ? Image.network(message)
            : Container(
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: isSender ? 12 : 30,
                  left: 15,
                  right: isSender ? 30 : 12,
                ),
                decoration: BoxDecoration(
                  color: isSender ? const Color(0xFF235380) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(isSender ? 12 : 0),
                    bottomRight: Radius.circular(isSender ? 0 : 12),
                  ),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isSender ? Colors.white : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
  }
}

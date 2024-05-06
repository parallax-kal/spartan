import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spartan/notifiers/CurrentRoomNotifier.dart';
import 'package:chat_composer/chat_composer.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:spartan/services/chat.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  TextEditingController chatTextController = TextEditingController();
  bool _emojiShowing = false;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CurrentRoomNotifier currentRoomNotifier =
        Provider.of<CurrentRoomNotifier>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color(0XFFF2F2F2),
      appBar: AppBar(
        leadingWidth: 30,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
            currentRoomNotifier.clearRoom();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(currentRoomNotifier.currentRoom!.profile),
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
                  '${currentRoomNotifier.currentRoom!.totalMembers} ${currentRoomNotifier.currentRoom!.private.toString()}',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [],
          ),
          ChatComposer(
            controller: chatTextController,
            leading: IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {},
            ),
            onReceiveText: (str) {
              print('TEXT : ' + str!);
            },
            onRecordEnd: (path) {
              print('AUDIO PATH : ' + path!);
            },
            actions: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _emojiShowing = !_emojiShowing;
                    });
                  },
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

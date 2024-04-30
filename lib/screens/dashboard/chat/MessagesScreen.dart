import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spartan/notifiers/CurrentRoomNotifier.dart';
import 'package:chat_composer/chat_composer.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    CurrentRoomNotifier currentRoomNotifier =
        Provider.of<CurrentRoomNotifier>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_backspace),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
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
                    fontSize: 20,
                  ),
                ),
                Text(
                  '${currentRoomNotifier.currentRoom!.totalMembers} Members',
                  style: const TextStyle(
                    color: Color(0XFF707070),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
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
            onReceiveText: (str) {
              print('TEXT : ' + str!);
            },
            onRecordEnd: (path) {
              print('AUDIO PATH : ' + path!);
            },
           actions: [
            
           ],
          ),
        ],
      ),
    );
  }
}

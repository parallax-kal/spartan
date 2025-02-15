// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Message.dart';
import 'package:spartan/models/Tip.dart';
import 'package:spartan/notifiers/CurrentRoomNotifier.dart';
import 'package:spartan/services/chat.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'package:spartan/models/SpartanUser.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    CurrentRoomNotifier currentRoomNotifier =
        Provider.of<CurrentRoomNotifier>(context, listen: true);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(500),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          )
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                      ),
                    ),
                    onTap: () {},
                  ),
                  Container(
                    width: 200,
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 0.5,
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TabBar(
                      dividerHeight: 0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0XFF002E58),
                      ),
                      tabs: const [
                        Tab(
                          text: 'Message',
                        ),
                        Tab(
                          text: 'Tips',
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(500),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          )
                        ],
                      ),
                      child: SvgPicture.asset('assets/icons/edit_line.svg'),
                    ),
                    onTap: () {
                      GoRouter.of(context).push('/chat/new-room');
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    StreamBuilder(
                      stream: ChatService.getAllRooms(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.data?.isEmpty ?? true) {
                              return const Center(
                                child: Text('No rooms found'),
                              );
                            }

                            return SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  final room = snapshot.data![index];

                                  return StreamBuilder(
                                    stream: CombineLatestStream.list([
                                      ChatService.getLastMessage(room.id!),
                                      ChatService.getUserStream(),
                                    ]),
                                    builder: ((context, snapshot) {
                                      QuerySnapshot<Map<String, dynamic>>?
                                          lastMessage = snapshot.data?[0]
                                              as QuerySnapshot<
                                                  Map<String, dynamic>>?;
                                      DocumentSnapshot<Map<String, dynamic>>?
                                          user = snapshot.data?[1]
                                              as DocumentSnapshot<
                                                  Map<String, dynamic>>?;
                                      int count = 0;
                                      if (user != null) {
                                        SpartanUser spartanUser =
                                            SpartanUser.fromJson({
                                          'id': user.id,
                                          ...?user.data()
                                        });

                                        count = spartanUser.unReadMessages
                                                ?.firstWhereOrNull((element) =>
                                                    element.roomId == room.id)
                                                ?.count ??
                                            0;
                                      }
                                      Message? message;
                                      String? formattedDate;
                                      if (lastMessage != null &&
                                          lastMessage.docs.isNotEmpty) {
                                        message = Message.fromJson({
                                          'id': lastMessage.docs.first.id,
                                          ...lastMessage.docs.first.data()
                                        });
                                        DateFormat format;

                                        if (DateTime.now()
                                                .difference(message.createdAt)
                                                .inDays ==
                                            0) {
                                          format = DateFormat('hh:mm a');
                                        } else if (DateTime.now().year ==
                                            message.createdAt.year) {
                                          format = DateFormat('dd MMM');
                                        } else {
                                          format = DateFormat('dd MMM yyyy');
                                        }

                                        formattedDate =
                                            format.format(message.createdAt);
                                      }
                                      return ListTile(
                                        title: Text(
                                          room.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundImage: room.profile == null
                                              ? null
                                              : NetworkImage(room.profile!),
                                          child: room.profile == null
                                              ? room.id == 'spartan_global'
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
                                        subtitle: (snapshot.connectionState ==
                                                    ConnectionState.waiting ||
                                                snapshot.connectionState ==
                                                    ConnectionState.none)
                                            ? const Text('Loading...')
                                            : message == null
                                                ? null
                                                : Text(
                                                    message.type ==
                                                            MESSAGETYPE.TEXT
                                                        ? message.message!
                                                        : 'Shared an ${message.type.name.toLowerCase()} file',
                                                    style: const TextStyle(
                                                      color: Color(0XFF707070),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                        trailing: message == null
                                            ? null
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  if (count == 0 &&
                                                      message.sender.uid ==
                                                          auth.currentUser!.uid)
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  Text(
                                                    formattedDate!,
                                                    style: const TextStyle(
                                                      color: Color(0XFF707070),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  if (count > 0 &&
                                                      message.sender.uid ==
                                                          auth.currentUser!.uid)
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0XFFED6400),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(500),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 4,
                                                        right: 4,
                                                      ),
                                                      child: Text(
                                                        count.toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  if (message.sender.uid ==
                                                      auth.currentUser!.uid)
                                                    SvgPicture.asset(room.group
                                                        ? 'assets/icons/ticks/single.svg'
                                                        : message.status ==
                                                                MESSAGESTATUS
                                                                    .SENT
                                                            ? 'assets/icons/ticks/single.svg'
                                                            : message.status ==
                                                                    MESSAGESTATUS
                                                                        .RECEIVED
                                                                ? 'assets/icons/ticks/double.svg'
                                                                : message.status ==
                                                                        MESSAGESTATUS
                                                                            .READ
                                                                    ? 'assets/icons/ticks/colored-double.svg'
                                                                    : 'assets/icons/single.svg')
                                                ],
                                              ),
                                        onTap: () async {
                                          if (room.id == 'spartan_global') {
                                            if (room.totalMembers == 0) {
                                              await room.getTotalMembers();
                                            }
                                          }
                                          currentRoomNotifier
                                              .setCurrentRoom(room);
                                          GoRouter.of(context)
                                              .push('/chat/messages');
                                        },
                                      );
                                    }),
                                  );
                                },
                              ),
                            );
                        }
                      },
                    ),
                    StreamBuilder(
                      stream: ChatService.getTips(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.done:
                          case ConnectionState.active:
                            if (snapshot.data?.docs.isEmpty ?? true) {
                              return const Center(
                                child: Text('No Tips yet'),
                              );
                            }
                            List<Tip> tips = snapshot.data!.docs
                                .map((tip) => Tip.fromJson(tip.data()))
                                .toList();

                            return SingleChildScrollView(
                              child: Column(
                                children: tips
                                    .map(
                                      (tip) => Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0XFFEFEFEF),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            tip.coverImage == null
                                                ? const SizedBox()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        tip.coverImage!,
                                                      ),
                                                    ),
                                                  ),
                                            Container(
                                              padding: const EdgeInsets.all(18),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFF000000)
                                                            .withOpacity(0.1),
                                                    offset: const Offset(0, 4),
                                                    blurRadius: 7.3,
                                                    spreadRadius: 0,
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                tip.description,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

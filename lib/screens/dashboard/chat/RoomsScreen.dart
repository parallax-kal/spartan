// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spartan/models/Message.dart';
import 'package:spartan/models/Room.dart';
import 'package:spartan/notifiers/CurrentRoomNotifier.dart';
import 'package:spartan/services/chat.dart';
import 'package:rxdart/rxdart.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({Key? key}) : super(key: key);

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
              const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
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
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: StreamBuilder(
                  stream: CombineLatestStream.list([
                    ChatService.getGlobalRoom(),
                    ChatService().getRooms(),
                  ]).map((event) {
                    final data = [
                      ...event[0].docs,
                      ...event[1].docs,
                    ];

                    return data;
                  }),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 227,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.data?.isEmpty ?? true) {
                          return const Center(
                            child: Text('No rooms found'),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final room = Room.fromJson(
                              {
                                'id': snapshot.data?[index].id,
                                ...?snapshot.data?[index].data()
                              },
                            );

                            return StreamBuilder(
                              stream: CombineLatestStream.list([
                                ChatService.getLastMessage(room.id),
                                ChatService.getUnreadRoomMessages(),
                              ]),
                              builder: ((context, snapshot) {
                                QuerySnapshot<Map<String, dynamic>>?
                                    lastMessage = snapshot.data?[0]
                                        as QuerySnapshot<Map<String, dynamic>>?;
                                DocumentSnapshot<Map<String, dynamic>>? user =
                                    snapshot.data?[1] as DocumentSnapshot<
                                        Map<String, dynamic>>?;

                                return ListTile(
                                  title: Text(
                                    room.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(room.profile),
                                  ),
                                  subtitle: (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          snapshot.connectionState ==
                                              ConnectionState.none)
                                      ? const Text('Loading...')
                                      : lastMessage?.docs.isEmpty ?? true
                                          ? null
                                          : const Text(
                                              'Is the baby sleeping well ?',
                                              style: TextStyle(
                                                color: Color(0XFF707070),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                  trailing: (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          snapshot.connectionState ==
                                              ConnectionState.none)
                                      ? null
                                      : lastMessage?.docs.isEmpty ?? true
                                          ? null
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  DateFormat('hh:mm a')
                                                      .format(Message.fromJson({
                                                    'id':
                                                        lastMessage!.docs[0].id,
                                                    ...lastMessage.docs[0]
                                                        .data(),
                                                  }).createdAt.toDate()),
                                                  style: const TextStyle(
                                                    color: Color(0XFF707070),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0XFFED6400),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            500),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 4,
                                                    right: 4,
                                                  ),
                                                  child: const Text(
                                                    '0',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                  onTap: () {
                                    currentRoomNotifier.setCurrentRoom(room);
                                    GoRouter.of(context).push('/chat/messages');
                                  },
                                );
                              }),
                            );
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

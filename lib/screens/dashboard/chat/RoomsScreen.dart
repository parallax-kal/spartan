import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spartan/models/Room.dart';
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
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      // border: Border.all(
                      //   color: const Color(0XFF002E58),
                      //   width: 1,
                      // ),
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
              SingleChildScrollView(
                child: StreamBuilder(
                  stream: CombineLatestStream.list([
                    ChatService.getGlobalRoom(),
                    ChatService().getRooms(),
                  ]),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final globalRoom = snapshot.data?[0].docs;
                        final otherRooms = snapshot.data?[1].docs;
                        if (globalRoom == null || globalRoom.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: const Center(
                              child: Text('No rooms found'),
                            ),
                          );
                        }
                        List data = [...globalRoom, ...otherRooms ?? []];

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final room = Room.fromJson(
                                {'id': data[index].id, ...data[index].data()});

                            return ListTile(
                              title: Text(room.name),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(room.profile),
                              ),
                              subtitle: Text(room.profile),
                              trailing: Text(
                                DateFormat('hh:mm a').format(
                                  room.lastMessageAt.toDate(),
                                ),
                              ),
                              onTap: () {
                                // GoRouter.of(context).push('/chat/${room.id}');
                              },
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

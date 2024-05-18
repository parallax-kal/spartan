import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Log.dart';
import 'package:spartan/models/Room.dart';
import 'package:spartan/notifiers/CurrentRoomNotifier.dart';
import 'package:spartan/notifiers/CurrentSpartanUserNotifier.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/log.dart';
import 'package:spartan/services/toast.dart';

class JoinCommunityScreen extends StatefulWidget {
  const JoinCommunityScreen({Key? key}) : super(key: key);

  @override
  State<JoinCommunityScreen> createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    CurrentRoomNotifier currentRoomNotifier =
        Provider.of<CurrentRoomNotifier>(context);
    CurrentSpartanUserNotifier currentSpartanUserNotifier =
        Provider.of<CurrentSpartanUserNotifier>(context);
    ToastService toastService = ToastService(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/community.svg'),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'The community contain all people around\nthe world including health cares, doctors and parents',
              style: TextStyle(
                color: Color(0xFF898787),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    LoadingService loadingService = LoadingService(context);
                    return SimpleDialog(
                      titlePadding:
                          const EdgeInsets.only(left: 30, right: 30, top: 30),
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      elevation: 7.3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      title: const Text(
                        'Do you wish to join spartan\nglobal community',
                        style: TextStyle(color: Colors.black),
                      ),
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'With spartan\'s global community you can stay updated and get some tips and advices.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color:
                                            Color.fromRGBO(209, 209, 209, 0.22),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color(0XFF908E8E),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  try {
                                    loadingService.show();
                                    final roomFire = await firestore
                                        .collection('rooms')
                                        .doc('spartan_global')
                                        .get();

                                    await firestore
                                        .collection('users')
                                        .doc(auth.currentUser!.uid)
                                        .update({'community': true});
                                    Room room = Room.fromJson({
                                      'id': 'spartan_global',
                                      ...roomFire.data()!
                                    });
                                    await room.getTotalMembers();
                                    currentSpartanUserNotifier
                                        .setCurrentSpartanUser(
                                      currentSpartanUserNotifier
                                          .currentSpartanUser!
                                          .copyWith(community: true),
                                    );

                                    currentRoomNotifier.setCurrentRoom(room);
                                    await LogService.addUserLog(
                                      Log(
                                        title: 'Joined Community',
                                        description:
                                            'Joined Spartan Global Community',
                                        createdAt: DateTime.now(),
                                      ),
                                    );
                                    toastService.showSuccessToast(
                                        'Joined Spartan Global Communty');
                                    GoRouter.of(context).push('/chat/messages');
                                  } catch (error) {
                                    print(error);
                                    // String message =
                                    //     displayErrorMessage(error);
                                    // toastService.showErrorToast(message);
                                  } finally {
                                    loadingService.hide();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color:
                                            Color.fromRGBO(209, 209, 209, 0.22),
                                        width: 2,
                                      ),
                                      left: BorderSide(
                                        color:
                                            Color.fromRGBO(209, 209, 209, 0.22),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Color(0xFF7ABFFF),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002E58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minimumSize: const Size(191, 42),
              ),
              child: const Text(
                'Join Community',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

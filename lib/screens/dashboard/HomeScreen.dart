import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/notifiers/CurrentSpartanUserNotifier.dart';
import 'package:provider/provider.dart';
import 'package:spartan/services/crib.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    CurrentSpartanUserNotifier currentSpartanUser =
        Provider.of<CurrentSpartanUserNotifier>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 35, left: 13, right: 13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints:
                    currentSpartanUser.currentSpartanUser?.community != true
                        ? null
                        : BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height - 380,
                          ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 16),
                      child: Image.asset(
                        'assets/images/parent_sitting.png',
                        width: 270,
                      ),
                    ),
                    StreamBuilder(
                        stream: CribService.countCribs(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.done:
                            case ConnectionState.active:
                              if (snapshot.data == 0) {
                                return Column(
                                  children: [
                                    const Text(
                                      'No cribs yet',
                                      style: TextStyle(
                                        color: Color(0xFF002E58),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Text(
                                      'You don\'t have any cribs connected yet.',
                                      style: TextStyle(
                                        color: Color(0xFF002E58),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF002E58),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                          barrierColor:
                                              Colors.black.withOpacity(0.3),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const HomeDialog();
                                          },
                                        );
                                      },
                                      child: const Text(
                                        '+ Add new crib',
                                        style: TextStyle(
                                          color: Color(0XFFF3F6FC),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                children: [
                                  const Text(
                                    'Cribs',
                                    style: TextStyle(
                                      color: Color(0xFF002E58),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'You have ${snapshot.data} cribs connected\ncheckout stream',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF002E58),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF002E58),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            barrierColor:
                                                Colors.black.withOpacity(0.3),
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const HomeDialog();
                                            },
                                          );
                                        },
                                        child: const Text(
                                          '+ Add new crib',
                                          style: TextStyle(
                                            color: Color(0XFFF3F6FC),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF002E58),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onPressed: () {
                                          GoRouter.of(context).push('/stream');
                                        },
                                        child: const Text(
                                          'Go to Stream',
                                          style: TextStyle(
                                            color: Color(0XFFF3F6FC),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                          }
                        }),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  currentSpartanUser.currentSpartanUser?.community == true
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF84AFEF).withOpacity(0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 24,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SvgPicture.asset(
                                      'assets/svg/ask_customer.svg'),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Join chat room for parenting',
                                    style: TextStyle(
                                      color: Color(0xFF747373),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Ask other parents and baby\ncare through our chat room',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      GoRouter.of(context).push('/chat');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF002E58),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text(
                                          'Join Chat room',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeDialog extends StatelessWidget {
  const HomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Crib onboarding options',
            style: TextStyle(
              color: Color(0xFF002E58),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SvgPicture.asset(
              'assets/icons/dialog_close.svg',
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 7.3,
      shadowColor: const Color(0xFF000000).withOpacity(0.4),
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: deviceAddingOptions
              .map((option) => InkWell(
                    onTap: () async {
                      if (option.label == 'Manual') {
                        GoRouter.of(context).push('/manual');
                      } else if (option.label == 'QR Code') {
                        GoRouter.of(context).push('/qrcode/initialize');
                      }
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width * 0.26,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 7.3,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0XFFBFD1F4),
                              borderRadius: BorderRadius.circular(500),
                            ),
                            child: option.icon,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            option.label,
                            style: const TextStyle(
                              color: Color(0XFF06345F),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class DeviceAddingOption {
  final String label;
  final Widget icon;

  DeviceAddingOption({required this.label, required this.icon});
}

List<DeviceAddingOption> deviceAddingOptions = [
  DeviceAddingOption(
    label: 'Manual',
    icon: SvgPicture.asset(
      'assets/icons/manual.svg',
    ),
  ),
  DeviceAddingOption(
    label: 'QR Code',
    icon: SvgPicture.asset(
      'assets/icons/qr_code.svg',
    ),
  ),
];

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/screens/dashboard/BottomNavigationContainer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class DeviceAddingOption {
  final String label;
  final Widget icon;

  DeviceAddingOption({required this.label, required this.icon});
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<DeviceAddingOption>> device_adding_options = [
    [
      DeviceAddingOption(
          label: 'Manual', icon: SvgPicture.asset('assets/icons/manual.svg')),
      DeviceAddingOption(
          label: 'QR Code', icon: SvgPicture.asset('assets/icons/qr_code.svg')),
    ],
    [
      DeviceAddingOption(
          label: 'Wi-Fi', icon: SvgPicture.asset('assets/icons/wifi.svg')),
      DeviceAddingOption(
          label: 'Bluetooth',
          icon: SvgPicture.asset('assets/icons/bluetooth.svg')),
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30, bottom: 50, left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Image.asset('assets/images/parent_sitting.png'),
                ),
                const Text(
                  'No devices yet',
                  style: TextStyle(
                    color: Color(0xFF002E58),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'You don\'t have any devices connected yet',
                  style: TextStyle(
                    color: Color(0xFF002E58),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002E58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      barrierColor: Colors.black.withOpacity(0.3),
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Device onboarding options',
                                style: TextStyle(
                                    color: Color(0xFF002E58),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
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
                          contentPadding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          elevation: 7.3,
                          shadowColor: Color(0xFF000000).withOpacity(0.4),
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: device_adding_options
                                  .map(
                                    (e) => Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: e
                                              .map((option) => InkWell(
                                                    onTap: () async {
                                                      if (option.label == 'Manual') {
                                                        GoRouter.of(context).pushNamed('/home/manual');
                                                      } else if (option.label == 'QR Code') {
                                                        GoRouter.of(context).pushNamed('/home/qr');
                                                      } else if (option.label == 'Wi-Fi') {
                                                        GoRouter.of(context).pushNamed('/home/wifi');
                                                      } else if (option.label == 'Bluetooth') {
                                                        GoRouter.of(context).pushNamed('/home/bluetooth');
                                                      }
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(
                                                                    0xFF000000)
                                                                .withOpacity(
                                                                    0.4),
                                                            offset:
                                                                const Offset(
                                                                    0, 4),
                                                            blurRadius: 7.3,
                                                            spreadRadius: 0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0XFFBFD1F4),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          500),
                                                            ),
                                                            child: option.icon,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            option.label,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF002E58),
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                        const SizedBox(
                                            height:
                                                10), // Add a SizedBox with height 10 between rows
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    '+ Add new device',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 30, left: 10, right: 10, bottom: 15),
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
                      SvgPicture.asset('assets/svg/ask_customer.svg'),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Join chat room for parenting',
                        style: TextStyle(
                          color: Color(0xFF747373),
                          fontSize: 10,
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
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          BottomNavigationContainer.changeTab(context, '/chat');
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
                              style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}

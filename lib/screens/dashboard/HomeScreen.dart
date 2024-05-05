import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/screens/dashboard/BottomNavigationContainer.dart';
import 'package:spartan/notifiers/CurrentSpartanUserNotifier.dart';
import 'package:provider/provider.dart';

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
  List<List<DeviceAddingOption>> deviceAddingOptions = [
    [
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
    ],
    [
      DeviceAddingOption(
          label: 'Wi-Fi',
          icon: SvgPicture.asset(
            'assets/icons/wifi.svg',
          )),
      DeviceAddingOption(
        label: 'Bluetooth',
        icon: SvgPicture.asset(
          'assets/icons/bluetooth.svg',
        ),
      ),
    ]
  ];

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
                    currentSpartanUser.currentSpartanUser?.community == true
                        ? null
                        : BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height - 335,
                          ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
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
                        fontSize: 12,
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
                        GoRouter.of(context).push('/home/qrcode');
                      },
                      child: const Text(
                        '+ Add new device',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              currentSpartanUser.currentSpartanUser?.community == true
                  ? Container()
                  : Container(
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
                                  BottomNavigationContainer.changeTab(
                                      context, '/chat');
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
        ),
      ),
    );
  }
}

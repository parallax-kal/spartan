import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spartan/screens/dashboard/BottomNavigationContainer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  

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
                            children: [],
                            contentPadding: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            // elevation: 7.3,
                            // shadowColor: Color(0xFF000000).withOpacity(0.4),
                          );
                        });
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

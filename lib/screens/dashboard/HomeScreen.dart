import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset('assets/images/logo.png'),
        leadingWidth: 160,
        actions: [
          Badge(
            child: SvgPicture.asset('assets/icons/notifications.svg'),
          ),
          const SizedBox(
            width: 15,
          ),
          const Icon(Icons.add),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_page.toString(), textScaleFactor: 10.0),
              ElevatedButton(
                child: const Text('Go To Page of index 1'),
                onPressed: () {
                  final CurvedNavigationBarState? navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState?.setPage(1);
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: [
          CurvedNavigationBarItem(
            child: _page == 0
                ? SvgPicture.asset('assets/icons/home/home_filled.svg',
                    theme: const SvgTheme(currentColor: Colors.white))
                : SvgPicture.asset(
                    'assets/icons/home/home_outlined.svg',
                    theme: const SvgTheme(
                      currentColor: Color(0XFF002E58),
                    ),
                  ),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: SvgPicture.asset(
              'assets/icons/chat.svg',
              theme: SvgTheme(
                currentColor:
                    _page == 1 ? Colors.white : const Color(0XFF002E58),
              ),
            ),
            label: 'Chat',
          ),
          CurvedNavigationBarItem(
            child: SvgPicture.asset(
              'assets/icons/stream.svg',
              theme: SvgTheme(
                currentColor:
                    _page == 2 ? Colors.white : const Color(0XFF002E58),
              ),
            ),
            label: 'Stream',
          ),
          CurvedNavigationBarItem(
            child: SvgPicture.asset(
              'assets/icons/profile.svg',
              theme: SvgTheme(
                currentColor:
                    _page == 3 ? Colors.white : const Color(0XFF002E58),
              ),
            ),
            label: 'Profile',
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: const Color(0xFF002E58),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

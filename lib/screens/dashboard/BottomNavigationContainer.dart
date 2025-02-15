import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

List<MyCustomBottomNavBarItem> tabs = [
  MyCustomBottomNavBarItem(
    initialLocation: Location.HOME,
    label: 'Home',
    child: SvgPicture.asset(
      'assets/icons/home/home_outlined.svg',
      theme: const SvgTheme(
        currentColor: Color(0XFF002E58),
      ),
    ),
    activeChild: SvgPicture.asset(
      'assets/icons/home/home_filled.svg',
      theme: const SvgTheme(currentColor: Colors.white),
    ),
  ),
  MyCustomBottomNavBarItem(
    initialLocation: Location.CHAT,
    label: 'Chat',
    child: SvgPicture.asset(
      'assets/icons/chat.svg',
      theme: const SvgTheme(
        currentColor: Color(0XFF002E58),
      ),
    ),
    activeChild: SvgPicture.asset(
      'assets/icons/chat.svg',
      theme: const SvgTheme(
        currentColor: Colors.white,
      ),
    ),
  ),
  MyCustomBottomNavBarItem(
    initialLocation: Location.STREAM,
    child: SvgPicture.asset(
      'assets/icons/stream.svg',
      theme: const SvgTheme(
        currentColor: Color(0XFF002E58),
      ),
    ),
    activeChild: SvgPicture.asset(
      'assets/icons/stream.svg',
      theme: const SvgTheme(
        currentColor: Colors.white,
      ),
    ),
    label: 'Stream',
  ),
  MyCustomBottomNavBarItem(
    initialLocation: Location.PROFILE,
    child: SvgPicture.asset(
      'assets/icons/profile/profile_outlined.svg',
      theme: const SvgTheme(
        currentColor: Color(0XFF002E58),
      ),
    ),
    activeChild: SvgPicture.asset(
      'assets/icons/profile/profile_filled.svg',
      theme: const SvgTheme(
        currentColor: Colors.white,
      ),
    ),
    label: 'Profile',
  ),
];

List<String> noAppbarScreens = [
  '/qrcode/initialize',
  '/crib/result',
  '/qrcode/scan',
  '/profile/index',
  '/stream/:id',
  '/chat/messages',
  '/chat/rooms',
  '/manual',
  '/crib/add',
  '/profile/settings',
  '/profile/user-data',
  '/profile/delete-account',
  '/profile/account-log',
  '/profile/edit-email',
  '/profile/edit-password',
  '/notifications',
  '/chat/new-room'
];

List noBottomNavScreens = ['/chat/messages', '/qrcode/scan'];

class BottomNavigationContainer extends StatefulWidget {
  final String path;
  const BottomNavigationContainer(
      {super.key, required this.child, required this.path});

  final Widget child;

  @override
  State<BottomNavigationContainer> createState() =>
      _BottomNavigationContainerState();
}

class _BottomNavigationContainerState extends State<BottomNavigationContainer> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _currentIndex = 0;

  changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _changeTab(BuildContext context, int index) {
    if (index == _currentIndex) return;
    GoRouter router = GoRouter.of(context);
    Location location = tabs[index].initialLocation;

    changeIndex(index);
    router.push(location.paths[0]);
  }

  @override
  void didUpdateWidget(covariant BottomNavigationContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    int index = tabs.indexWhere(
        (element) => element.initialLocation.paths.contains(widget.path));
    if (index == -1) return;
    changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !noAppbarScreens.contains(widget.path)
          ? AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              leadingWidth: 110,
              actions: [
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push('/notifications');
                  },
                  child: Badge(
                    label: Text('2'),
                    isLabelVisible: false,
                    child: SvgPicture.asset(
                      'assets/icons/notifications.svg',
                      width: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: !noBottomNavScreens.contains(widget.path)
          ? Container(
              height: 72,
              padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 11,
                    offset: const Offset(0, 0),
                  )
                ],
              ),
              child: CurvedNavigationBar(
                key: _bottomNavigationKey,
                height: 74,
                color: Colors.transparent,
                index: _currentIndex,
                items: tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;
                  return CurvedNavigationBarItem(
                    child: tab.initialLocation.paths.contains(widget.path)
                        ? tab.activeChild
                        : index == _currentIndex
                            ? tab.activeChild
                            : tab.child,
                    label: tab.label,
                  );
                }).toList(),
                buttonBackgroundColor: const Color(0xFF002E58),
                backgroundColor: Colors.white,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 600),
                onTap: (index) {
                  _changeTab(context, index);
                },
                letIndexChange: (index) => true,
              ),
            )
          : null,
    );
  }
}

enum Location {
  HOME(['/', '/qrcode/initialize', '/crib/result', '/crib/add', '/manual']),
  CHAT(['/chat', '/chat/rooms', '/chat/messages', '/chat/join-community']),
  STREAM([
    '/stream',
  ]),
  PROFILE([
    '/profile/index',
    '/profile/settings',
    '/profile/user-data',
    '/profile/delete-account',
    '/profile/account-log',
    '/profile/edit-email',
    '/profile/edit-password',
  ]);

  final List<String> paths;

  const Location(this.paths);
}

class MyCustomBottomNavBarItem extends CurvedNavigationBarItem {
  final Location initialLocation;
  final Widget activeChild;

  const MyCustomBottomNavBarItem({
    required this.initialLocation,
    required this.activeChild,
    required Widget child,
    required String label,
  }) : super(
          child: child,
          label: label,
        );
}

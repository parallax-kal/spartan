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

List<String> noAppbarScreens = ['/home/qr', '/home/qrcode-success', '/profile'];

class BottomNavigationContainer extends StatefulWidget {
  final String location;
  const BottomNavigationContainer(
      {super.key, required this.child, required this.location});

  final Widget child;
  static void changeTab(BuildContext context, String location) {
    int index = tabs.indexWhere(
        (element) => element.initialLocation.paths.contains(location));
    if (index == -1) return;
    GoRouter router = GoRouter.of(context);
    _BottomNavigationContainerState? state =
        context.findAncestorStateOfType<_BottomNavigationContainerState>();
    state?.changeIndex(index);
    router.pushNamed(location);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !noAppbarScreens.contains(widget.location)
          ? AppBar(
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
            )
          : null,
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _currentIndex,
        items: tabs.map((tab) {
          return CurvedNavigationBarItem(
            child: tab.initialLocation.paths.contains(widget.location)
                ? tab.activeChild
                : tab.child,
            label: tab.label,
          );
        }).toList(),
        color: Colors.white,
        buttonBackgroundColor: const Color(0xFF002E58),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          _changeTab(context, index);
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

enum Location {
  HOME(['/', '/home/qr']),
  CHAT(['/chat']),
  STREAM(['/stream']),
  PROFILE(['/profile']);

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

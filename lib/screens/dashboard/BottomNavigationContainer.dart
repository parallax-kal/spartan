import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationContainer  extends StatefulWidget {
  final String location;
  const BottomNavigationContainer({super.key, required this.child, required this.location});
  final Widget child;

  @override
  State<BottomNavigationContainer> createState() => _BottomNavigationContainerState();
}

class _BottomNavigationContainerState extends State<BottomNavigationContainer> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _currentIndex = 0;

  static List<MyCustomBottomNavBarItem> tabs = [
    MyCustomBottomNavBarItem(
      initialLocation: '/',
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
      initialLocation: '/chat',
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
      initialLocation: '/stream',
      child: SvgPicture.asset(
        'assets/icons/stream.svg',
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
      label: 'Stream',
    ),
    MyCustomBottomNavBarItem(
      initialLocation: '/profile',
      child: SvgPicture.asset(
        'assets/icons/profile.svg',
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
      label: 'Profile',
    ),
  ];

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
      body: SafeArea(child: widget.child,),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: tabs.map((tab) {
          return CurvedNavigationBarItem(
            child: tab.initialLocation == widget.location
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
          _goOtherTab(context, index);
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  void _goOtherTab(BuildContext context, int index) {
    if (index == _currentIndex) return;
    GoRouter router = GoRouter.of(context);
    String location = tabs[index].initialLocation;

    setState(() {
      _currentIndex = index;
    });
    router.go(location);
  }
}

class MyCustomBottomNavBarItem extends CurvedNavigationBarItem {
  final String initialLocation;
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

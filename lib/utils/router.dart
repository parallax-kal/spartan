import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/constants/global.dart';
import 'package:spartan/models/Crib.dart';
import 'package:spartan/models/SpartanUser.dart';
import 'package:spartan/notifiers/CurrentSpartanUserNotifier.dart';
import 'package:spartan/screens/dashboard/NotificationsScreen.dart';
import 'package:spartan/screens/dashboard/chat/MessagesScreen.dart';
import 'package:spartan/screens/dashboard/BottomNavigationContainer.dart';
import 'package:spartan/screens/auth/CountryScreen.dart';
import 'package:spartan/screens/auth/ForgotPasswordScreen.dart';
import 'package:spartan/screens/auth/LoginScreen.dart';
import 'package:spartan/screens/auth/RegisterScreen.dart';
import 'package:spartan/screens/auth/TermsAndConditions.dart';
import 'package:spartan/screens/auth/TermsOfService.dart';
import 'package:spartan/screens/dashboard/chat/JoinCommunityScreen.dart';
import 'package:spartan/screens/dashboard/HomeScreen.dart';
import 'package:spartan/screens/dashboard/ProfileScreen.dart';
import 'package:spartan/screens/dashboard/StreamScreen.dart';
import 'package:spartan/screens/dashboard/chat/NewRoomScreen.dart';
import 'package:spartan/screens/dashboard/chat/RoomsScreen.dart';
import 'package:spartan/screens/dashboard/crib/AddCribScreen.dart';
import 'package:spartan/screens/dashboard/profile/AccountLogScreen.dart';
import 'package:spartan/screens/dashboard/profile/DeleteAccountScreen.dart';
import 'package:spartan/screens/dashboard/profile/EditEmailScreen.dart';
import 'package:spartan/screens/dashboard/profile/ProfileDataScreen.dart';
import 'package:spartan/screens/dashboard/profile/SettingsScreen.dart';
import 'package:spartan/screens/dashboard/qrcode/InitializeQrcodeScreen.dart';
import 'package:spartan/screens/dashboard/qrcode/ScanQrcodeScreen.dart';
import 'package:spartan/screens/dashboard/crib/ResultCribScreen.dart';
import 'package:spartan/screens/dashboard/stream/PreviewStreamScreen.dart';
import 'package:spartan/screens/manual/ManualScreen.dart';
import 'package:spartan/utils/notifications.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation:
      NotificationController().initialAction != null ? '/notifications' : '/',
  navigatorKey: rootNavigatorKey,
  redirect: (context, state) async {
    if (publicRoutes.contains(state.fullPath)) {
      return null;
    }

    final userAutheticated = auth.currentUser != null;
    if (!userAutheticated && !publicRoutes.contains(state.fullPath)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
      if (isFirstTime) {
        await prefs.setBool('isFirstTime', false);
        return '/register';
      } else {
        return '/login';
      }
    }

    CurrentSpartanUserNotifier currentSpartanUserNotifier =
        Provider.of<CurrentSpartanUserNotifier>(
      context,
      listen: false,
    );

    if (currentSpartanUserNotifier.currentSpartanUser == null) {
      final user =
          await firestore.collection('users').doc(auth.currentUser!.uid).get();

      if (!user.exists) {
        currentSpartanUserNotifier.clearSpartanUser();
        return '/login';
      }

      final spartanUser =
          SpartanUser.fromJson({'id': user.id, ...user.data()!});

      currentSpartanUserNotifier.setCurrentSpartanUser(spartanUser);
    }

    return null;
  },
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: BottomNavigationContainer(
            path: state.fullPath ?? '/',
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          parentNavigatorKey: shellNavigatorKey,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: '/notifications',
          parentNavigatorKey: shellNavigatorKey,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const NotificationsScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/qrcode',
          parentNavigatorKey: shellNavigatorKey,
          redirect: (context, state) {
            if (state.fullPath == '/qrcode') {
              return '/qrcode/initialize';
            }
            return null;
          },
          routes: [
            GoRoute(
              path: 'scan',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  child: const ScanQrcodeScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: 'initialize',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const InitializeQrcodeScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/crib',
          parentNavigatorKey: shellNavigatorKey,
          redirect: (context, state) {
            if (state.fullPath == '/crib') {
              return '/crib/add';
            }
            return null;
          },
          routes: [
            GoRoute(
              path: 'add',
              pageBuilder: (context, state) {
                Crib? crib = state.extra as Crib?;
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: AddCribScreen(crib: crib),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: 'result',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ResultCribScreen(result: state.extra),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/manual',
          parentNavigatorKey: shellNavigatorKey,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const ManualScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/chat',
          parentNavigatorKey: shellNavigatorKey,
          redirect: (context, state) async {
            CurrentSpartanUserNotifier currentSpartanUserNotifier =
                Provider.of<CurrentSpartanUserNotifier>(
              context,
              listen: false,
            );

            if (currentSpartanUserNotifier.currentSpartanUser == null) {
              return '/login';
            }

            if (state.fullPath == '/chat') {
              if (currentSpartanUserNotifier.currentSpartanUser!.community ==
                  true) {
                return '/chat/rooms';
              } else {
                return '/chat/join-community';
              }
            }

            return null;
          },
          routes: [
            GoRoute(
              path: 'new-room',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: NewConversationScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: 'join-community',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const JoinCommunityScreen(),
                );
              },
            ),
            GoRoute(
              path: 'rooms',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const RoomsScreen(),
                );
              },
            ),
            GoRoute(
              path: 'messages',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const MessagesScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/stream',
          parentNavigatorKey: shellNavigatorKey,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: const StreamScreen(),
            );
          },
        ),
        GoRoute(
          path: '/stream/preview',
          parentNavigatorKey: shellNavigatorKey,
          pageBuilder: (context, state) {
            Crib crib = state.extra as Crib;
            return CustomTransitionPage(
              key: state.pageKey,
              child:  PreviewStreamScreen(crib: crib,),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/profile',
          parentNavigatorKey: shellNavigatorKey,
          redirect: (context, state) {
            if (state.fullPath == '/profile') {
              return '/profile/index';
            }
            return null;
          },
          routes: [
            GoRoute(
              path: 'index',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const ProfileScreen(),
                );
              },
            ),
            GoRoute(
              path: 'settings',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  child: const SettingsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: 'user-data',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  child: const ProfileDataScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: 'account-log',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  child: const AccountLogScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: 'delete-account',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  child: const DeleteAccountScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: 'edit-email',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  child: const EditEmailScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/forgot',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: '/register',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
      path: '/location',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CountryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/terms-of-service',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TermsOfService(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/terms-and-conditions',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TermsAndConditions(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    )
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/services/auth.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

List<ProfileOption> profileOptions = [
  ProfileOption(
    title: 'Profile',
    icon: 'assets/icons/profile/profile_outlined.svg',
    onPressed: (BuildContext context) {
      GoRouter.of(context).push('/user-data');
    },
  ),
  ProfileOption(
    title: 'Settings',
    icon: 'assets/icons/settings.svg',
    onPressed: (BuildContext context) {
      GoRouter.of(context).push('/settings');
    },
  ),
  // ProfileOption(
  //   title: 'Help Center',
  //   icon: 'assets/icons/alert.svg',
  //   onPressed: () {},
  // ),
  // ProfileOption(
  //   title: 'Feedback',
  //   icon: 'assets/icons/feedback.svg',
  //   onPressed: () {},
  // ),
  // ProfileOption(
  //   title: 'App info',
  //   icon: 'assets/icons/info.svg',
  //   onPressed: () {},
  // )
];

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    LoadingService loadingService = LoadingService(context);
    ToastService toastService = ToastService(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    bottom: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                child: auth.currentUser!.photoURL != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                            auth.currentUser!.photoURL!,
                                            scale: 0.5,
                                            maxHeight: 60,
                                            maxWidth: 60,
                                          ),
                                          loadingBuilder: (
                                            BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? imageChunkEvent,
                                          ) =>
                                              imageChunkEvent == null
                                                  ? child
                                                  : const CircularProgressIndicator(),
                                          errorBuilder: (
                                            BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace,
                                          ) {
                                            return SvgPicture.asset(
                                              'assets/icons/profile/profile_outlined.svg',
                                              width: 70,
                                              height: 70,
                                            );
                                          },
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/icons/profile/profile_outlined.svg',
                                        width: 70,
                                        height: 70,
                                      ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 8,
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x00000040),
                                          blurRadius: 4.8,
                                          spreadRadius: 0,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/edit.svg',
                                      width: 12,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            auth.currentUser!.displayName!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            auth.currentUser!.email!,
                            style: const TextStyle(
                              fontFamily: 'InriaSans',
                              color: Color(0xFF828282),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: profileOptions
                                  .asMap()
                                  .map(
                                    (index, option) => MapEntry(
                                      index,
                                      GestureDetector(
                                        onTap: () {
                                          option.onPressed(context);
                                        },
                                        child: Container(
                                          color: index == 0
                                              ? const Color.fromRGBO(
                                                  96, 139, 228, 0.15)
                                              : null,
                                          padding: const EdgeInsets.only(
                                            left: 40,
                                            top: 15,
                                            bottom: 15,
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                option.icon,
                                                theme: SvgTheme(
                                                  currentColor: index == 0
                                                      ? Colors.black
                                                      : const Color(0XFF565656),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 50,
                                              ),
                                              Text(
                                                option.title,
                                                style: TextStyle(
                                                  color: index == 0
                                                      ? Colors.black
                                                      : const Color(0XFF565656),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        textColor: const Color(0xFF8C8C8C),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                                titlePadding: const EdgeInsets.all(0),
                                contentPadding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.white,
                                elevation: 7.3,
                                shadowColor:
                                    const Color(0xFF000000).withOpacity(0.4),
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/logo.png',
                                    height: 35,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    'You are about to log\nout of the system',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Do you wish to continue?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0XFF969696),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () async {
                                        try {
                                          loadingService.show();
                                          await authService.signOut();
                                          toastService.showSuccessToast(
                                            'You have been logged out successfully!',
                                          );
                                          context.go('/login');
                                        } catch (error) {
                                          String errorMessage =
                                              displayErrorMessage(
                                                  error as Exception);
                                          toastService
                                              .showErrorToast(errorMessage);
                                        } finally {
                                          loadingService.hide();
                                        }
                                      },
                                      child: const Text(
                                        'Continue',
                                        style: TextStyle(
                                          color: Color(0XFF7ABFFF),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Logout')
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 90,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x00000040),
                      blurRadius: 25.6,
                      spreadRadius: 0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/svg/two_triangles.svg',
                  width: 110,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption {
  final String title;
  final String icon;
  final Function(BuildContext context) onPressed;

  ProfileOption({
    required this.title,
    required this.icon,
    required this.onPressed,
  });
}

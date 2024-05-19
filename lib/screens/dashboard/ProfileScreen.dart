// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/notifiers/CurrentSpartanUserNotifier.dart';
import 'package:spartan/services/auth.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

List<ProfileOption> profileOptions = [
  ProfileOption(
    title: 'Profile',
    icon: 'assets/icons/profile/profile_outlined.svg',
    onPressed: (BuildContext context) {
      GoRouter.of(context).push('/profile/user-data');
    },
  ),
  ProfileOption(
    title: 'Settings',
    icon: 'assets/icons/settings.svg',
    onPressed: (BuildContext context) {
      GoRouter.of(context).push('/profile/settings');
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
  late String? profile;

  @override
  void initState() {
    super.initState();
    profile = auth.currentUser!.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    LoadingService loadingService = LoadingService(context);
    ToastService toastService = ToastService(context);
    ImagePicker picker = ImagePicker();
    CurrentSpartanUserNotifier currentSpartanUserNotifier =
        Provider.of<CurrentSpartanUserNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 55,
                bottom: 10,
              ),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            profile == null
                                ? CircleAvatar(
                                    radius: 48,
                                    backgroundImage: NetworkImage(
                                      profile!,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 48,
                                    child: SvgPicture.asset(
                                      'assets/icons/profile/profile_outlined.svg',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                            Positioned(
                              right: 0,
                              bottom: 8,
                              child: InkWell(
                                onTap: () async {
                                  final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (image == null) {
                                    return;
                                  }
                                  File imageFile = File(image.path);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      LoadingService loadingService =
                                          LoadingService(context);
                                      ToastService toastService =
                                          ToastService(context);

                                      return SimpleDialog(
                                        titlePadding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                        ),
                                        backgroundColor: Colors.white,
                                        surfaceTintColor: Colors.white,
                                        elevation: 7.3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        title: const Text(
                                          'Do you wish to use this image as your profile image',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        children: [
                                          const SizedBox(height: 15),
                                          CircleAvatar(
                                            radius: 48,
                                            backgroundImage: FileImage(
                                              imageFile,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                      color: Color(0xFFDFDFDF),
                                                      width: 2),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF0C3D6B),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  try {
                                                    loadingService.show(
                                                        message:
                                                            'Uploading...');
                                                    String filename =
                                                        'profile_pictures/${auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                                                    await storage
                                                        .ref(filename)
                                                        .putFile(imageFile);
                                                    String downloadURL =
                                                        await storage
                                                            .ref(filename)
                                                            .getDownloadURL();
                                                    await authService
                                                        .updateProfilePicture(
                                                            downloadURL);
                                                    setState(() {
                                                      profile = downloadURL;
                                                    });
                                                    toastService.showSuccessToast(
                                                        'Profile picture updated successfully!');
                                                  } catch (error) {
                                                    String errorMessage =
                                                        displayErrorMessage(
                                                            error);
                                                    toastService.showErrorToast(
                                                        errorMessage);
                                                  } finally {
                                                    loadingService.hide();
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: const Text(
                                                  'Continue',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.5,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15)
                                        ],
                                      );
                                    },
                                  );
                                },
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
                        auth.currentUser?.displayName != null
                            ? Text(
                                auth.currentUser!.displayName!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 3,
                        ),
                        auth.currentUser?.email != null
                            ? Text(
                                auth.currentUser!.email!,
                                style: const TextStyle(
                                  color: Color(0xFF828282),
                                ),
                              )
                            : const SizedBox(),
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
                      height: 80,
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
                                  'You are about to log\nout from Spartan',
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
                                        currentSpartanUserNotifier
                                            .clearSpartanUser();
                                        toastService.showSuccessToast(
                                          'You have been logged out successfully!',
                                        );
                                        context.go('/login');
                                      } catch (error) {
                                        String errorMessage =
                                            displayErrorMessage(error);
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
            Positioned(
              top: 11,
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

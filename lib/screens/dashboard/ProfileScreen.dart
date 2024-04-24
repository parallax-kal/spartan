import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/services/auth.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

List<ProfileOption> profileOptions = [
  ProfileOption(
    title: 'Profile',
    icon: SvgPicture.asset('assets/icons/profile/profile_outlined.svg'),
    onPressed: () {},
  ),
  ProfileOption(
    title: 'Settings',
    icon: SvgPicture.asset('assets/icons/settings.svg'),
    onPressed: () {},
  ),
  ProfileOption(
    title: 'Help Center',
    icon: SvgPicture.asset('assets/icons/alert.svg'),
    onPressed: () {},
  ),
  ProfileOption(
    title: 'Feedback',
    icon: SvgPicture.asset('assets/icons/feedback.svg'),
    onPressed: () {},
  ),
  ProfileOption(
    title: 'App info',
    icon: SvgPicture.asset('assets/icons/info.svg'),
    onPressed: () {},
  )
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.84,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('hello'),
                      MaterialButton(
                        textColor: Color(0xFF8C8C8C),
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
                                displayErrorMessage(error as Exception);
                            toastService.showErrorToast(errorMessage);
                          } finally {
                            loadingService.hide();
                          }
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
              top: 80,
              right: 0,
              child: SvgPicture.asset('assets/svg/two_triangles.svg'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption {
  final String title;
  final Widget icon;
  final Function() onPressed;

  ProfileOption({
    required this.title,
    required this.icon,
    required this.onPressed,
  });
}

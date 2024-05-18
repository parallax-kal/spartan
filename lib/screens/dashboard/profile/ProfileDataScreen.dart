import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDataScreen extends StatefulWidget {
  const ProfileDataScreen({super.key});

  @override
  State<ProfileDataScreen> createState() => _ProfileDataScreenState();
}

class _ProfileDataScreenState extends State<ProfileDataScreen> {
  @override
  Widget build(BuildContext context) {
    LoadingService loadingService = LoadingService(context);
    ToastService toastService = ToastService(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            children: [
              Center(
                child: auth.currentUser!.photoURL != null
                    ? CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(
                          auth.currentUser!.photoURL!,
                        ),
                      )
                    : SvgPicture.asset(
                        'assets/icons/profile/profile_outlined.svg',
                        width: 65,
                        height: 65,
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 7.3,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).push('/profile/edit-email');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            auth.currentUser!.email!,
                            style: const TextStyle(
                              color: Color(0XFF929292),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.06),
                      offset: const Offset(0, 4),
                      blurRadius: 7.3,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    try {
                      loadingService.show(message: 'Sending');
                      await auth.sendPasswordResetEmail(
                        email: auth.currentUser!.email!,
                        actionCodeSettings: ActionCodeSettings(
                          url: 'https://spartancorp.io',
                          handleCodeInApp: true,
                          iOSBundleId: 'com.spartan.app',
                          androidPackageName: 'com.spartan.app',
                          androidInstallApp: true,
                          androidMinimumVersion: '16',
                        ),
                      );
                      toastService.showSuccessToast(
                        'Password reset link sent to your email',
                      );
                    } catch (error) {
                      String errorMessage =
                          displayErrorMessage(error);
                      toastService.showErrorToast(errorMessage);
                    } finally {
                      loadingService.hide();
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

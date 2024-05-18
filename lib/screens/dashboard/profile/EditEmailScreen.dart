import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({super.key});

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  TextEditingController newEmailController = TextEditingController();
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
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 25,
          top: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'New Email',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: newEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(
                        color: Color(0xFFDFDFDF),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(
                        color: Color(0xFF1455A9),
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                )
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C3D6B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size(double.infinity, 40),
              ),
              onPressed: () async {
                try {
                  loadingService.show(message: 'Sending...');
                  await auth.currentUser!.verifyBeforeUpdateEmail(
                    newEmailController.text,
                    ActionCodeSettings(
                      url: 'https://spartancorp.io',
                      handleCodeInApp: true,
                      iOSBundleId: 'com.spartan.app',
                      androidPackageName: 'com.spartan.app',
                      androidInstallApp: true,
                      androidMinimumVersion: '16',
                    ),
                  );
                  toastService.showSuccessToast(
                      'A verification email has been sent to ${auth.currentUser!.email!}.');
                } catch (error) {
                  String errorMessage = displayErrorMessage(error as Exception);
                  toastService.showErrorToast(errorMessage);
                } finally {
                  loadingService.hide();
                }
              },
              child: const Text(
                'Change Email',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

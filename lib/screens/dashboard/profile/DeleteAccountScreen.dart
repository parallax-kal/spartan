import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Log.dart';
import 'package:spartan/services/auth.dart';
import 'package:spartan/services/crib.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/log.dart';
import 'package:spartan/services/toast.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
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
        centerTitle: true,
        title: const Text(
          'Delete Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.privacy_tip,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'About closing your acount',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                """Before you proceed, please take a moment to consider: Are you sure you want to delete this item? This action is irreversible and will permanently remove the selected accountfrom your account. Any associated data will also be deleted. To confirm, tap the 'Delete' button below. If you have any concerns or need assistance, you can contact our support team. Please be aware that this action cannot be undone. Thank you for your understanding.""",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                """Before you proceed, please take a moment to consider: Are you sure you want to delete this item? This action is irreversible and will permanently remove the selected accountfrom your account. Any associated data will also be deleted. To confirm, tap the 'Delete' button below. If you have any concerns or need assistance, you can contact our support team. Please be aware that this action cannot be undone. Thank you for your understanding.""",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    loadingService.show();
                    await CribService.deleteAllCribs();
                    LogService.addUserLog(
                      Log(
                        title: 'Deleted Account',
                        description: 'User has deleted their account',
                        createdAt: DateTime.now(),
                      ),
                    );
                    await authService.deleteAccount();
                    toastService.showSuccessToast(
                      'You have deleted your account successfully!',
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C3D6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

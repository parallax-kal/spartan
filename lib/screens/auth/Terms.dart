import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/notifiers/LocationTermsNotifier.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';

class Terms extends StatefulWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    LocationAndTermsNotifier usermodel = Provider.of<LocationAndTermsNotifier>(context, listen: false);
    LoadingService loadingService = LoadingService(context);
    ToastService toastService = ToastService(context);

    Future<void> saveUserData() async {
      try {
        if (auth.currentUser == null) {
          context.go('/login');
          return;
        }
        loadingService.show();
        await firestore.collection('users').doc(auth.currentUser!.uid).update(
          {
            'country': usermodel.country,
            'terms': usermodel.acceptedTerms,
          },
        );
        toastService
            .showSuccessToast('Successfully saved your decition and country.');
        context.go('/');
      } catch (error) {
        toastService.showErrorToast('Failed to accept terms of service.');
      } finally {
        loadingService.hide();
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Color(0XFF8B8B8B),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 141,
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('I accept the '),
                    Text(
                      'Terms of service',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1976D2),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text('and confirm that I have  ')
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('fully read and understand '),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1976D2),
                        decoration: TextDecoration.underline,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 50, left: 10, right: 10),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    usermodel.changeTerms(true);
                    await saveUserData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C3D6B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    usermodel.changeTerms(false);
                    await saveUserData();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0C3D6B), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  child: const Text(
                    'Withdrawal',
                    style: TextStyle(
                      color: Color(0xFF0C3D6B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

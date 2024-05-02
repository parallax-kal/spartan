import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/notifiers/CountryTermsNotifier.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';

class TermsOfService extends StatefulWidget {
  const TermsOfService({Key? key}) : super(key: key);

  @override
  _TermsOfServiceState createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  @override
  Widget build(BuildContext context) {
    CountryAndTermsNotifier usermodel =
        Provider.of<CountryAndTermsNotifier>(context, listen: false);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
         backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0XFF8B8B8B),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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
                  width: 150,
                ),
                const SizedBox(height: 35),
                const Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'I accept the '),
                        TextSpan(
                          text: 'Terms of service',
                          style: TextStyle(
                            color: Color(0XFF1976D2),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' and confirm that I have fully read and understand ',
                        ),
                        TextSpan(
                          text: 'Privacy',
                          style: TextStyle(
                            color: Color(0XFF1976D2),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                          text: 'Policy',
                          style: TextStyle(
                            color: Color(0XFF1976D2),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 60, left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/terms-and-conditions');
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
          ),
        ],
      ),
    );
  }
}

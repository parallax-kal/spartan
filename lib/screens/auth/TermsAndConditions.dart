import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/constants/global.dart';
import 'package:spartan/models/Log.dart';
import 'package:spartan/notifiers/CountryTermsNotifier.dart';
import 'package:spartan/services/log.dart';
import 'package:spartan/services/toast.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  DateTime lastUpdateDate = DateTime(2024, 20, 5);
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    CountryAndTermsNotifier usermodel =
        Provider.of<CountryAndTermsNotifier>(context, listen: false);
    ToastService toastService = ToastService(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: loading
          ? null
          : AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0XFF8B8B8B),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text(
                'Terms and conditions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0XFF0C3D6B),
                ),
              ),
            ),
      body: loading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    copyrightText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0XFF3A3A3A),
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last updated ${DateFormat('MMMM dd, yyyy').format(lastUpdateDate)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'AGREEMENT TO OUR LEGAL TERMS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            termsandconditonstext,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 80)
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 40),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color(0xFF0C3D6B), width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width / 2.6,
                                  36,
                                ),
                              ),
                              onPressed: () {
                                toastService.showErrorToast(
                                    'Yout must Agree with the terms and conditons to use this app');
                              },
                              child: const Text(
                                'Decline',
                                style: TextStyle(
                                  color: Color(0xFF0C3D6B),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    loading = true;
                                  });
                                  usermodel.changeTerms(true);
                                  if (auth.currentUser == null) {
                                    context.go('/login');
                                    return;
                                  }
                                  await firestore
                                      .collection('users')
                                      .doc(auth.currentUser!.uid)
                                      .update(
                                    {
                                      'country': usermodel.country,
                                      'terms': usermodel.acceptedTerms,
                                    },
                                  );
                                  await LogService.addUserLog(
                                    Log(
                                      title: 'Country Selected',
                                      description:
                                          'Country selected as ${usermodel.country}',
                                      createdAt: DateTime.now(),
                                    ),
                                  );
                                  await LogService.addUserLog(
                                    Log(
                                      title: 'Terms Accepted',
                                      description:
                                          'Terms and Conditions accepted',
                                      createdAt: DateTime.now(),
                                    ),
                                  );
                                  toastService.showSuccessToast(
                                      'Accepted Terms and conditions');
                                  GoRouter.of(context).push('/');
                                } catch (error) {
                                  toastService.showErrorToast(
                                      'Error while saving your decision');
                                } finally {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C3D6B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width / 2.6,
                                  36,
                                ),
                              ),
                              child: const Text(
                                'Agree',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
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

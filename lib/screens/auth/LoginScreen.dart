import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/constants/global.dart';
import 'package:spartan/models/Log.dart';
import 'package:spartan/models/SpartanUser.dart';
import 'package:spartan/services/auth.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/log.dart';
import 'package:spartan/services/toast.dart';
import 'package:spartan/utils/notifications.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    ToastService toastService = ToastService(context);
    LoadingService loadingService = LoadingService(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 19,
            padding:
                const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const Text(
                        'Sign in with email',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF7A7A7A),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _emailController,
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
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          hintText: 'Password',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide:
                                BorderSide(color: Color(0xFFDFDFDF), width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide:
                                BorderSide(color: Color(0xFF1455A9), width: 2),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          RegExp regex = RegExp(
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&_])[A-Za-z\d$@$!%*?&_]{8,}$');
                          if (!regex.hasMatch(value)) {
                            return 'Password must contain at least 8 characters, one uppercase, one lowercase, one number and one special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            GoRouter.of(context).push('/forgot');
                          },
                          child: const Text(
                            'Forgot Password ?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              loadingService.show();
                              UserCredential userCredential =
                                  await authService.signInWithEmailAndPassword(
                                      _emailController.text,
                                      _passwordController.text);

                              if (!userCredential.user!.emailVerified) {
                                await userCredential.user!
                                    .sendEmailVerification(
                                  ActionCodeSettings(
                                    url: 'https://spartancorp.io',
                                    handleCodeInApp: true,
                                    iOSBundleId: 'com.spartan.app',
                                    androidPackageName: 'com.spartan.app',
                                    androidInstallApp: true,
                                  ),
                                );

                                return;
                              }
                              final user = await firestore
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .get();
                              final userData = user.data();
                              if (userData?['status'] ==
                                  USERSTATUS.DELETED.name) {
                                toastService.showErrorToast(
                                    'This account has been deleted wait for 7 days to reactivate it');
                                return;
                              }

                              // String token =
                              //     NotificationController().firebaseToken;
                              // if (token.isEmpty) {
                              await NotificationController
                                  .displayNotificationRationale();
                              String token = await NotificationController
                                  .requestFirebaseToken();
                              // }

                              await firestore
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .update({
                                'tokens': [token]
                              });
                              final address = await authService.getLocation();

                              await LogService.addUserLog(
                                Log(
                                  title: 'Logged in account',
                                  description:
                                      'From ${address['country_name']} ${address['country_capital']} with ip ${address['ip']}',
                                  createdAt: DateTime.now(),
                                ),
                              );

                              toastService.showSuccessToast(
                                'Successfully signed in with email and password',
                              );
                              context.go('/');
                            } catch (error) {
                              String errorMessage = displayErrorMessage(error);
                              toastService.showErrorToast(errorMessage);
                            } finally {
                              loadingService.hide();
                            }
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
                          'Sign In',
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
                Column(
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        try {
                          AuthCredential authCredential =
                              await authService.signInWithGoogle();
                          loadingService.show();

                          UserCredential userCredential =
                              await auth.signInWithCredential(authCredential);
                          final user = await firestore
                              .collection('users')
                              .doc(userCredential.user!.uid)
                              .get();
                          final userData = user.data();
                          if (userData?['status'] == USERSTATUS.DELETED.name) {
                            toastService.showErrorToast(
                              'This account has been deactivated contact us for info',
                            );
                            return;
                          }
                          if (!user.exists) {
                            toastService.showErrorToast(
                              'This account does not exist go to signup page.',
                            );
                          } else {
                            final userData = user.data();
                            if (userData?['status'] ==
                                USERSTATUS.DELETED.name) {
                              await authService.signOut();
                              toastService.showErrorToast(
                                  'This account has been deactivated contact us for info');
                              return;
                            }

                            await NotificationController
                                  .displayNotificationRationale();
                              String token = await NotificationController
                                  .requestFirebaseToken();

                            await firestore
                                .collection('users')
                                .doc(userCredential.user!.uid)
                                .update({
                              'tokens': [token]
                            });

                            final address = await authService.getLocation();

                            await LogService.addUserLog(
                              Log(
                                title: 'Logged in account',
                                description:
                                    'From ${address['country_name']} ${address['country_capital']} with ip ${address['ip']}',
                                createdAt: DateTime.now(),
                              ),
                            );

                            toastService.showSuccessToast(
                              'You have successfully signed in with Google.',
                            );
                            context.go('/');
                          }

                          return;
                        } catch (error) {
                          String errorMessage = displayErrorMessage(error);
                          toastService.showErrorToast(errorMessage);
                        } finally {
                          loadingService.hide();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFFDFDFDF), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/google.svg',
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1455A9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svg/facebook.svg'),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Continue with Facebook',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        try {
                          loadingService.show();
                          OAuthCredential oAuthCredential =
                              await authService.signInWithFacebook();

                          UserCredential userCredential =
                              await auth.signInWithCredential(oAuthCredential);

                          final user = await firestore
                              .collection('users')
                              .doc(userCredential.user!.uid)
                              .get();

                          if (!user.exists) {
                            toastService.showErrorToast(
                                'This account does not exist go to signup page to create an account');
                          } else {
                            final userData = user.data();
                            if (userData?['status'] ==
                                USERSTATUS.DELETED.name) {
                              toastService.showErrorToast(
                                  'This account has been deleted wait for 7 days to reactivate it');
                              await authService.signOut();
                              return;
                            }

                           await NotificationController
                                  .displayNotificationRationale();
                              String token = await NotificationController
                                  .requestFirebaseToken();

                            await firestore
                                .collection('users')
                                .doc(userCredential.user!.uid)
                                .update({
                              'tokens': [token]
                            });

                            final address = await authService.getLocation();

                            await LogService.addUserLog(
                              Log(
                                title: 'Logged in account',
                                description:
                                    'From ${address['country_name']} ${address['country_capital']} with ip ${address['ip']}',
                                createdAt: DateTime.now(),
                              ),
                            );

                            toastService.showSuccessToast(
                              'You have successfully signed in with Facebook.',
                            );
                            context.go('/');
                          }
                        } catch (error) {
                          String errorMessage = displayErrorMessage(error);
                          toastService.showErrorToast(errorMessage);
                        } finally {
                          loadingService.hide();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'New here ?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/register');
                          },
                          child: const Text(
                            'Create a new one',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF0C3D6B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      copyrightText,
                      style: const TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 12,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

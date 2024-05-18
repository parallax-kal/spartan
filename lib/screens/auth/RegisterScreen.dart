import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spartan/constants/global.dart';
import 'package:spartan/models/SpartanUser.dart';
import 'package:spartan/services/auth.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/log.dart';
import 'package:spartan/services/toast.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Log.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
            padding: const EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 5,
            ),
            height: MediaQuery.of(context).size.height - 19,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Create a New Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const Text(
                        'Using an email',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF7A7A7A),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _fullnameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          hintText: 'Enter your full name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide:
                                BorderSide(color: Color(0xFFDFDFDF), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide:
                                BorderSide(color: Color(0xFF1455A9), width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.length < 3) {
                            return 'Full name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
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
                            borderSide:
                                BorderSide(color: Color(0xFFDFDFDF), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide:
                                BorderSide(color: Color(0xFF1455A9), width: 2),
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
                            return 'Password must contain at least 8 characters,\none uppercase, one lowercase, one number and one special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          hintText: 'Confirm Password',
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
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              loadingService.show();
                              UserCredential userCredential =
                                  await authService.signUpWithEmailAndPassword(
                                      _emailController.text,
                                      _passwordController.text);

                              await userCredential.user!
                                  .updateDisplayName(_fullnameController.text);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('isFirstTime', false);
                              String? token = await messaging.getToken();

                              await firestore
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'email': _emailController.text,
                                'fullname': _fullnameController.text,
                                'unReadMessages': [],
                                'status': USERSTATUS.ACTIVE.name,
                                'tokens': [token],
                              });

                              await userCredential.user!.sendEmailVerification(
                                ActionCodeSettings(
                                  url: 'https://spartancorp.io',
                                  handleCodeInApp: true,
                                  iOSBundleId: 'com.spartan.app',
                                  androidPackageName: 'com.spartan.app',
                                  androidInstallApp: true,
                                  androidMinimumVersion: '16',
                                ),
                              );
                              await authService.signOut();
                              _emailController.clear();
                              _passwordController.clear();
                              _confirmPasswordController.clear();

                              final address = await authService.getLocation();

                              await LogService.addUserLog(
                                Log(
                                  title: 'Created account',
                                  description:
                                      'From ${address['country_name']} ${address['country_capital']} with ip ${address['ip']}',
                                  createdAt: DateTime.now(),
                                ),
                              );

                              toastService.showSuccessToast(
                                'Email has been sent to your email please verify it and login.',
                              );
                            } catch (error) {
                              String errorMessage =
                                  displayErrorMessage(error as Exception);
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
                          'Create Account',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          try {
                            AuthCredential authCredential =
                                await authService.signInWithGoogle();
                            loadingService.show();

                            UserCredential userCredential =
                                await auth.signInWithCredential(authCredential);

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('isFirstTime', false);

                            final user = await firestore
                                .collection('users')
                                .doc(userCredential.user!.uid)
                                .get();
                            String? token = await messaging.getToken();
                            if (!user.exists) {
                              await firestore
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'email': userCredential.user!.email,
                                'fullname': userCredential.user!.displayName,
                                'profile': userCredential.user!.photoURL,
                                'unReadMessages': [],
                                'status': USERSTATUS.ACTIVE.name,
                                'tokens': [token],
                              });
                              final address = await authService.getLocation();

                              await LogService.addUserLog(
                                Log(
                                  title: 'Created account',
                                  description:
                                      'From ${address['country_name']} ${address['country_capital']} with ip ${address['ip']}',
                                  createdAt: DateTime.now(),
                                ),
                              );

                              toastService.showSuccessToast(
                                'You have successfully signed in with Google.',
                              );
                              context.push('/location');
                            } else {
                              toastService.showErrorToast(
                                'You have already signed up with this email. login instead',
                              );
                            }
                          } catch (error) {
                            String errorMessage =
                                displayErrorMessage(error as Exception);
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

                            UserCredential userCredential = await auth
                                .signInWithCredential(oAuthCredential);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('isFirstTime', false);
                            final user = await firestore
                                .collection('users')
                                .doc(userCredential.user!.uid)
                                .get();

                            String? token = await messaging.getToken();
                            if (!user.exists) {
                              await firestore
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'email': userCredential.user!.email,
                                'fullname': userCredential.user!.displayName,
                                'profile': userCredential.user!.photoURL,
                                'unReadMessages': [],
                                'status': USERSTATUS.ACTIVE.name,
                                'tokens': [token],
                              });

                              final address = await authService.getLocation();
                              await LogService.addUserLog(
                                Log(
                                  title: 'Created account',
                                  description:
                                      'From ${address['country_name']} ${address['country_capital']} with ip ${address['ip']}',
                                  createdAt: DateTime.now(),
                                ),
                              );
                              toastService.showSuccessToast(
                                'You have successfully signed in with Facebook.',
                              );
                              context.push('/location');
                              return;
                            } else {
                              toastService.showErrorToast(
                                'You have already signed up with this email. login instead',
                              );
                            }
                          } catch (error) {
                            String errorMessage =
                                displayErrorMessage(error as Exception);
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
                            'Already have an account ?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.getBool('isFirstTime') == null) {
                                await prefs.setBool('isFirstTime', false);
                              }
                              context.push('/login');
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xFF0C3D6B),
                              ),
                            ),
                          )
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
      ),
    );
  }
}

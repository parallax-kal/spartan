import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/models/User.dart';
import 'package:spartan/services/auth.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';
import 'package:spartan/constants/firebase.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    AuthService authService = AuthService();
    ToastService toastService = ToastService(context);
    LoadingService loadingService = LoadingService(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 25,
            right: 25,
            bottom: 10,
          ),
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide(color: Color(0xFF0C3D6B)),
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
                      height: 20,
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
                          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide(color: Color(0xFF0C3D6B)),
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
                      height: 20,
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
                          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide(color: Color(0xFF0C3D6B)),
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
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          try {
                            loadingService.show();
                            UserCredential userCredential = await authService
                                .signUpWithEmailAndPassword(email, password);

                            await userCredential.user!.sendEmailVerification(
                              ActionCodeSettings(
                                url: 'https://spartan.ai',
                                handleCodeInApp: true,
                                iOSBundleId: 'com.spartan.app',
                                androidPackageName: 'com.spartan.app',
                                androidInstallApp: true,
                                androidMinimumVersion: '16',
                                dynamicLinkDomain: 'spartancorp.page.link',
                              ),
                            );
                            await authService.signOut();
                            _emailController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();
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
                    OutlinedButton(
                      onPressed: () async {
                        try {
                          AuthCredential authCredential =
                              await authService.signInWithGoogle();
                          loadingService.show();

                          UserCredential userCredential =
                              await auth.signInWithCredential(authCredential);

                          UserModel userModel = UserModel();
                          toastService.showSuccessToast(
                            'You have successfully signed in with Google.',
                          );

                          DocumentSnapshot<Map<String, dynamic>> user_data =
                              await userModel
                                  .getUserData(userCredential.user!.uid);

                          if (!userModel.countrySet(user_data)) {
                            context.push('/location');
                            return;
                          }

                          if (!userModel.termsSet(user_data)) {
                            context.push('/terms');
                            return;
                          }

                          context.push('/');
                          
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

                          await auth.signInWithCredential(oAuthCredential);

                          toastService.showSuccessToast(
                            'You have successfully signed in with Facebook.',
                          );
                          context.go('/');
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
                          onTap: () {
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
                      'Copyright \u00a9$currentYear Spartans Inc. All rights reserved.',
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

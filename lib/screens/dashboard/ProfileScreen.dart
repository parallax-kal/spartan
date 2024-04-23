import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spartan/constants/firebase.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          auth.currentUser!.photoURL!,
                          errorBuilder: (context, error, stackTrace) {
                            return SvgPicture.asset(
                                'assets/icons/profile/profile_filled.svg');
                          },
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

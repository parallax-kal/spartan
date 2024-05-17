import 'package:flutter/material.dart';

class AccountLogScreen extends StatefulWidget {
  const AccountLogScreen({super.key});

  @override
  State<AccountLogScreen> createState() => _AccountLogScreenState();
}

class _AccountLogScreenState extends State<AccountLogScreen> {
  @override
  Widget build(BuildContext context) {
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
          'Account Log',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

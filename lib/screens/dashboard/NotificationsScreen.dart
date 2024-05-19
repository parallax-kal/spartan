import 'package:flutter/material.dart';

class NotificationsSCreen extends StatefulWidget {
  const NotificationsSCreen({super.key});

  @override
  State<NotificationsSCreen> createState() => _NotificationsSCreenState();
}

class _NotificationsSCreenState extends State<NotificationsSCreen> {
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
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Text('Notifications'),
      ),
    );
  }
}

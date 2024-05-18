import 'package:flutter/material.dart';

class NotificationsSCreen extends StatefulWidget {
  @override
  State<NotificationsSCreen> createState() => _NotificationsSCreenState();
}

class _NotificationsSCreenState extends State<NotificationsSCreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text('Notifications'),
      ),
    );
  }
}

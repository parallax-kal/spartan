import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class MessagesScreen extends StatefulWidget {
  final String room;
  const MessagesScreen({
    super.key,
    required this.room,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {

  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

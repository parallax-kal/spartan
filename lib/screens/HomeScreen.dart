import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spartan'),
      ),
      body: Container(
        child: GestureDetector(
          onTap: () {
           context.go('/login');
          },
          child: Center(
            child: Text('Go to Login'),
          ),
        ),
      ),
    );
  }
}

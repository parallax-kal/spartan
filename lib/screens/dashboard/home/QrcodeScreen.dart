import 'package:flutter/material.dart';

class QRcodeScreen extends StatefulWidget {
  @override
  _QRcodeScreenState createState() => _QRcodeScreenState();
}

class _QRcodeScreenState extends State<QRcodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF083B69),
      body: BottomSheet(
        enableDrag: false,
        onClosing: () {},
        showDragHandle: true,
        dragHandleColor: const Color(0xFFD9D9D9),
        dragHandleSize: const Size(50, 4),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(34),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
          );
        },
      ),
    );
  }
}

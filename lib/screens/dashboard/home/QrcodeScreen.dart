import 'package:flutter/material.dart';

class QRcodeScreen extends StatefulWidget {
  @override
  _QRcodeScreenState createState() => _QRcodeScreenState();
}

class _QRcodeScreenState extends State<QRcodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Scan QR Code',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const ScanScreen()),
                // ); 
              },
              child: const Text('Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
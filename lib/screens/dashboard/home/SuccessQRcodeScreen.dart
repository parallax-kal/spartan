import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessQRcodeScreen extends StatefulWidget {
  @override
  _SuccessQRcodeScreenState createState() => _SuccessQRcodeScreenState();
}

class _SuccessQRcodeScreenState extends State<SuccessQRcodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/success.svg'),
            const SizedBox(height: 20),
            const Text(
              'You have successfully added a new device. You can\nnow personalize your device by tapping on continue\nor skip for later changes.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0XFF002E58),
                    ),
                  ),
                  child: const Text(
                    'Skip for later',
                    style: TextStyle(
                      color: Color(0XFF002E58),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF002E58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size(83, 32),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Color(0XFFF3F6FC),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

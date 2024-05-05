import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spartan/services/crib.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class UniqueStreamScreen extends StatefulWidget {
  const UniqueStreamScreen({Key? key}) : super(key: key);

  @override
  State<UniqueStreamScreen> createState() => _UniqueStreamScreenState();
}

class _UniqueStreamScreenState extends State<UniqueStreamScreen> {
  Future _changeStatus() async {
    await CribService.updateCrib('spartan_crib_12343234232', {
      'status': false,
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.run(() async {
      if (!mounted) {
        return;
      }

      print('checking');

      try {
        await http.get(Uri.parse('http://192.168.43.68:8000/check'));
      } catch (error) {
        await _changeStatus();
        if (!mounted) return;
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final spartancamera = WebViewController()
      ..setNavigationDelegate(
          NavigationDelegate(onPageFinished: (String url) async {
        await _changeStatus();
        if (!mounted) return;
        Navigator.pop(context);
      }))
      ..loadRequest(
        Uri.parse('http://192.168.43.68:8000/stream.mjpg'),
      );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: WebViewWidget(controller: spartancamera),
                ),
                Positioned(
                  top: 20,
                  left: 5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 35,
                        ),
                        Text(
                          'C1CC(574231748)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 35,
                  top: 20,
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/share.svg'),
                      const SizedBox(
                        width: 15,
                      ),
                      SvgPicture.asset('assets/icons/rounded_settings.svg'),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/pause.svg'),
                      const SizedBox(
                        width: 15,
                      ),
                      SvgPicture.asset('assets/icons/volume.svg'),
                      const SizedBox(
                        width: 15,
                      ),
                      SvgPicture.asset('assets/icons/microphone.svg'),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: InkWell(
                    child: SvgPicture.asset('assets/icons/full_screen.svg'),
                    onTap: () async {
                      await spartancamera.loadRequest(
                        Uri.parse('http://youtube.com'),
                      );
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 10),
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/filter.svg'),
                      ],
                    ),
                    const Text(
                      'Event viewer',
                      style: TextStyle(
                        color: Color(0xFF004A87),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spartan/services/crib.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:spartan/models/Crib.dart';

class PreviewStreamScreen extends StatefulWidget {
  final Crib crib;
  const PreviewStreamScreen({super.key, required this.crib});

  @override
  State<PreviewStreamScreen> createState() => _PreviewStreamScreenState();
}

class _PreviewStreamScreenState extends State<PreviewStreamScreen> {
  Future _changeStatus() async {
    await CribService.updateCrib(widget.crib.id, {
      'status': STATUS.INACTIVE.name,
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.run(() async {
      if (!mounted) {
        return;
      }

      try {
        await http.get(Uri.parse('http://${widget.crib.ipaddress}:8000/check'));
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
      ..loadRequest(
        Uri.parse('http://${widget.crib.ipaddress}:8000'),
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
                  height: 400,
                  child: WebViewWidget(controller: spartancamera),
                ),
                Positioned(
                  top: 20,
                  left: 5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 35,
                        ),
                        Text(
                          widget.crib.name ?? 'Crib',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 10),
              child: Column(
                children: [
                  Row(
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
                  SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 500,
                      child: const Center(
                        child: Text('No Recent Events yet'),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

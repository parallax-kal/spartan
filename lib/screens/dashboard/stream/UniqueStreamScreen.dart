import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UniqueStreamScreen extends StatefulWidget {
  const UniqueStreamScreen({Key? key}) : super(key: key);

  @override
  State<UniqueStreamScreen> createState() => _UniqueStreamScreenState();
}

class _UniqueStreamScreenState extends State<UniqueStreamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/sample_stream.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
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
                  child: SvgPicture.asset('assets/icons/full_screen.svg'),
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

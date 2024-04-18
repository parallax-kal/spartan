import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Text(
            'Cameras',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            width: double.infinity,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  context.push('/stream/C1CC574231748');
                },
                child: Stack(
                  children: [
                    Positioned(
                      child: Image.asset(
                        'assets/images/sample_stream.png',
                      ),
                    ),
                    const Positioned(
                      top: 7,
                      left: 13,
                      child: Icon(
                        Icons.wifi,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/dot.svg'),
                              const SizedBox(width: 10),
                              const Text(
                                'Disarmed',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'C1CC(574231748)',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Positioned(
                      bottom: 10,
                      right: 20,
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 173,
              child: OutlinedButton(
                onPressed: () {
                  showBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BottomSheet(
                            onClosing: () {},
                            showDragHandle: false,
                            animationController: AnimationController(
                              vsync: this,
                              duration: const Duration(milliseconds: 300),
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(34),
                                topRight: Radius.circular(34),
                              ),
                            ),
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            backgroundColor: Colors.white,
                            enableDrag: false,
                            builder: (BuildContext context) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Icon(Icons.close,
                                            color: Colors.black),
                                      ),
                                      const Text('Layout Style'),
                                      const SizedBox()
                                    ],
                                  )
                                ],
                              );
                            });
                      });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0XFF848484),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/two_blocks.svg'),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Edit Devices',
                      style: TextStyle(
                        color: Color(0xFF606060),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

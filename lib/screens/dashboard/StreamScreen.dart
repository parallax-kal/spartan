import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spartan/notifiers/StreamLayoutNotifier.dart';

class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    StreamModel streamModel = Provider.of<StreamModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 32,
          right: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                child: InkWell(
                  onTap: () {
                    context.push('/stream/C1CC574231748');
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            'assets/images/sample_stream.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
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
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      builder: (BuildContext context) {
                        return BottomSheet(
                          onClosing: () {},
                          backgroundColor: Colors.white,
                          enableDrag: false,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 25,
                                left: 25,
                                right: 40,
                                bottom: 30,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            const Text(
                                              'Layout Style',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Choose how you would like to view\nall you devices',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF646464),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: const Color(0XFFCFCFCF),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          'Device View',
                                          style: TextStyle(
                                            color: Color(0XFF848484),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: DeviceView.values
                                              .map(
                                                (deviceview) => Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        SvgPicture.asset(
                                                          deviceview ==
                                                                  streamModel
                                                                      .layout
                                                                      .deviceView
                                                              ? 'assets/icons/checked.svg'
                                                              : 'assets/icons/circle.svg',
                                                          height: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          deviceview.value,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          'Sort By',
                                          style: TextStyle(
                                            color: Color(0XFF848484),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: SortBy.values
                                              .map(
                                                (sortby) => Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        SvgPicture.asset(
                                                          sortby ==
                                                                  streamModel
                                                                      .layout
                                                                      .sortBy
                                                              ? 'assets/icons/checked.svg'
                                                              : 'assets/icons/circle.svg',
                                                          height: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          sortby.value,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 55,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.grid_view_sharp,
                                                color: Color(0XFF004A87),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'Rearrange',
                                                style: TextStyle(
                                                  color: Color(0XFF004A87),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
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
      ),
    );
  }
}

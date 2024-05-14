import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Crib.dart';
import 'package:spartan/screens/dashboard/BottomNavigationContainer.dart';
import 'package:spartan/services/crib.dart';

class SuccessQRcodeScreen extends StatefulWidget {
  final dynamic result;
  const SuccessQRcodeScreen({super.key, required this.result});

  @override
  State<SuccessQRcodeScreen> createState() => _SuccessQRcodeScreenState();
}

class _SuccessQRcodeScreenState extends State<SuccessQRcodeScreen> {
  bool isProcessing = true;
  String? error;
  String? errorTitle;

  @override
  void initState() {
    super.initState();
    if (widget.result is Map && widget.result['result'] is String) {
      String qrcodeId = widget.result['result'];
      _processQRCode(qrcodeId);
    } else {
      setState(() {
        errorTitle = "Invalid QR code";
        error = 'You suplied an invalid qr code.\nPlease try again';
        isProcessing = false;
      });
    }
  }

  void _processQRCode(String qrcodeId) {
    CribService.getCrib(qrcodeId).then((value) {
      if (value == null) {
        _createCrib(qrcodeId);
      } else {
        setState(() {
          errorTitle = 'Device already added';
          error =
              'This device has been already registered by another one.\nPlease try another device or let us know\nif you are the owner of this device.';
          isProcessing = false;
        });
      }
    });
  }

  void _createCrib(String qrcodeId) {
    Crib crib = Crib(
      id: qrcodeId,
      access: [Access(status: ACCESSSTATUS.ADMIN, user: auth.currentUser!.uid)],
    );
    CribService.createCrib(crib).then((value) {
      setState(() {
        isProcessing = false;
      });
    });
  }

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
      body: isProcessing
          ? const ProcessingResult()
          : error != null
              ? ErrorResult(
                  error: error!,
                  errorTitle: errorTitle!,
                )
              : const SuccessResult(),
    );
  }
}

class ProcessingResult extends StatelessWidget {
  const ProcessingResult({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorResult extends StatelessWidget {
  final String error;
  final String errorTitle;
  const ErrorResult({super.key, required this.error, required this.errorTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/svg/error.svg'),
          const SizedBox(height: 10),
          Text(
            errorTitle,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            error,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: const BorderSide(
                    color: Color(0XFF002E58),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Color(0XFF002E58),
                      size: 20,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      'Retry',
                      style: TextStyle(
                        color: Color(0XFF002E58),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/stream');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF002E58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  // minimumSize: const Size(83, 32),
                ),
                child: const Text(
                  'Go to Stream',
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
    );
  }
}

class SuccessResult extends StatelessWidget {
  const SuccessResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/svg/success.svg'),
          const SizedBox(height: 10),
          const Text(
            'Success',
            style: TextStyle(
              color: Color(0XFF002E58),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'You have successfully added a new device. You can\nnow personalize your device by tapping on continue\nor skip for later changes.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  BottomNavigationContainer.changeTab(context, '/stream');
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
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
                onPressed: () {
                  GoRouter.of(context).push('/device/update');
                },
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
    );
  }
}

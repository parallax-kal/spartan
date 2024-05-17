import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Crib.dart';
import 'package:spartan/models/Log.dart';
import 'package:spartan/notifiers/CurrentCribIdNotifier.dart';
import 'package:spartan/screens/dashboard/BottomNavigationContainer.dart';
import 'package:spartan/services/crib.dart';
import 'package:spartan/services/log.dart';

class ResultCribScreen extends StatefulWidget {
  final dynamic result;
  const ResultCribScreen({super.key, required this.result});

  @override
  State<ResultCribScreen> createState() => _ResultCribScreenState();
}

class _ResultCribScreenState extends State<ResultCribScreen> {
  bool isProcessing = true;
  String? error;
  String? errorTitle;

  @override
  void initState() {
    if (widget.result is Map && widget.result['result'] is String) {
      String qrcodeId = widget.result['result'];
      if (!qrcodeId.startsWith('spartan_crib_')) {
        _setErrorState("Invalid QR code",
            "You supplied an invalid QR code. Please try again.");
      } else {
        _processQRCode(qrcodeId);
      }
    } else {
      _setErrorState("Invalid QR code",
          "You supplied an invalid QR code. Please try again.");
    }
    super.initState();
  }

  void _processQRCode(String qrcodeId) {
    CribService.getCrib(qrcodeId).then((cribData) {
      if (!cribData.exists) {
        _setErrorState(
          "Crib not found",
          "The crib you are trying to connect to does not exist. Please try another crib or contact support if you are the owner.",
        );
      } else {
        Crib crib = Crib.fromJson(
          {
            'id': cribData.id,
            ...?cribData.data(),
          },
        );

        bool hasAdmin =
            crib.access.any((access) => access.status == ACCESSSTATUS.ADMIN);

        if (!hasAdmin) {
          _updateCrib(crib);
        } else {
          bool isOwner = crib.access.any((access) =>
              access.status == ACCESSSTATUS.ADMIN &&
              access.user == auth.currentUser!.email);

          bool isAlreadyConnected =
              crib.users.contains(auth.currentUser!.email);

          _setErrorState(
            "Crib already added",
            isOwner
                ? "You are the owner of this crib. Go to Stream to Personalize it"
                : isAlreadyConnected
                    ? "You have already connected to this crib. You can now personalize your crib by tapping on continue or skip for later changes."
                    : "This crib has already been registered by another user. Please try another crib or contact support if you are the owner.",
          );
        }
      }
    }).catchError((error) {
      print(error);
      _setErrorState(
        "Error",
        "There was an error while processing the crib data.",
      );
    });
  }

  void _updateCrib(Crib previous) {
    CribService.updateCrib(previous.id, {
      'access': FieldValue.arrayUnion([
        {
          'status': ACCESSSTATUS.ADMIN.name,
          'user': auth.currentUser!.email,
        }
      ]),
      'users': FieldValue.arrayUnion([auth.currentUser!.uid]),
    }).then((value) {
      LogService.addUserLog(
        Log(
          title: 'Added Crib',
          description: 'Added a new crib with ID ${previous.id}',
          createdAt: DateTime.now(),
        ),
      );
      _setProcessingState(false);
    }).catchError((error) {
      _setErrorState(
          "Error", "There was an error while updating the crib data.");
    });
  }

  void _setErrorState(String title, String errorMessage) {
    setState(() {
      errorTitle = title;
      error = errorMessage;
      isProcessing = false;
    });
  }

  void _setProcessingState(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    CurrentCribIdNotifier currentCribIdNotifier =
        Provider.of<CurrentCribIdNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
            currentCribIdNotifier.setCribId(null);
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
    CurrentCribIdNotifier currentCribIdNotifier =
        Provider.of<CurrentCribIdNotifier>(context);

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
                  Navigator.of(context).pop();
                  currentCribIdNotifier.setCribId(null);
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
                  BottomNavigationContainer.changeTab(context, '/stream');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF002E58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Go to Stream',
                  style: TextStyle(
                    color: Color(0XFFF3F6FC),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
            'You have successfully added a new crib. You can now personalize your crib by tapping on\ncontinue or skip for later changes.',
            textAlign: TextAlign.center,
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
                child: const Row(
                  children: [
                    Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0XFF002E58),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.keyboard_double_arrow_right,
                      size: 20,
                      color: Color(0XFF002E58),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/crib/add');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF002E58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
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

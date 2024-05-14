import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class InitializeQrcodeScreen extends StatefulWidget {

  const InitializeQrcodeScreen({super.key});

  @override
  State<InitializeQrcodeScreen> createState() => _InitializeQrcodeScreenState();
}

class _InitializeQrcodeScreenState extends State<InitializeQrcodeScreen>
    with TickerProviderStateMixin {
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF083B69),
      bottomSheet: BottomSheet(
        enableDrag: false,
        onClosing: () {},
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
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
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          minWidth: MediaQuery.of(context).size.width,
        ),
        builder: (BuildContext context) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Scan QR code',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Place the qr code inside the frame to scan\nplease avoid shake to get result quickly',
                style: TextStyle(
                    color: Color(0xFF4B4B4B),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 0),
              ),
              const SizedBox(
                height: 50,
              ),
              SvgPicture.asset('assets/svg/qr_code.svg'),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/qrcode/scan');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF002E58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(83, 32),
                ),
                child: const Text(
                  'Scan',
                  style: TextStyle(
                    color: Color(0xFFF3F6FC),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

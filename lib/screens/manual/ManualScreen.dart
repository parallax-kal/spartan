import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spartan/notifiers/CurrentCribIdNotifier.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  final TextEditingController _deviceSinController = TextEditingController();
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
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Input your Crib Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Look for the SN (Serial number) on your crib and enter it below',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 5.9,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/sin_sample.jpg',
                  width: 230,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _deviceSinController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  hintText: 'Please enter the serial number.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Color(0xFFDFDFDF), width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.length != 11) {
                    return 'Enter valid SN';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    currentCribIdNotifier
                        .setCribId('spartan_crib_${_deviceSinController.text}');
                    GoRouter.of(context).push('/crib/result', extra: {
                      'result': 'spartan_crib_${_deviceSinController.text}',
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF002E58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Connect',
                    style: TextStyle(
                      color: Color(0XFFF3F6FC),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF908E8E),
      body: const SafeArea(
        child: Text('Select a region'),
      ),
      bottomNavigationBar: DraggableScrollableSheet(
        minChildSize: .80,
        maxChildSize: 1,
        initialChildSize: .80,
        expand: false,
        builder: (context, scrollController) {
          return Stack(
            children: [
              Positioned(
                child: Container(
                  padding: const EdgeInsets.only(top: 50),
                ),
              ),
             Positioned(child:  Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(67),
                    topRight: Radius.circular(67),
                  ),
                ),
                child: Column(
                  children: [
                    const Center(
                      child: Text("Title"),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 25,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(title: Text('Item $index'));
                        },
                      ),
                    ),
                  ],
                ),
              ),),
              Positioned(child: Container(
                padding: const EdgeInsets.only(top: 50),
              )),
              Positioned(
                top: -70,
                right: 0,
                child: Image.asset('assets/images/map.png'),
              ),
            ],
          );
        },
      ),
    );
  }
}

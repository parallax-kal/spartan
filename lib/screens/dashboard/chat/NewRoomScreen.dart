import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class NewConversationScreen extends StatefulWidget {
  @override
  State<NewConversationScreen> createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  File? profile;
  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: const Text(
            'Create a new Conversation',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 250,
                  height: 40,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 0.5,
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: TabBar(
                    dividerHeight: 0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0XFF002E58),
                    ),
                    tabs: const [
                      Tab(
                        text: 'Conversation',
                      ),
                      Tab(
                        text: 'People',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: Stack(
                  children: [
                    profile != null
                        ? CircleAvatar(
                            radius: 48,
                            backgroundImage: FileImage(
                              profile!,
                            ),
                          )
                        : const Icon(Icons.group),
                    Positioned(
                      right: 0,
                      bottom: 8,
                      child: InkWell(
                        onTap: () async {
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image == null) return;
                          profile = File(image.path);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x00000040),
                                blurRadius: 4.8,
                                spreadRadius: 0,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/edit.svg',
                            width: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

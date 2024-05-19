import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Room.dart';
import 'package:spartan/models/SpartanUser.dart';
import 'package:spartan/services/auth.dart';
import 'package:spartan/services/chat.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';

class NewConversationScreen extends StatefulWidget {
  const NewConversationScreen({super.key});

  @override
  State<NewConversationScreen> createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  String name = '';
  File? profile;

  List<String> selectedUsers = [];
  bool private = false;

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    AuthService authService = AuthService();
    LoadingService loadingService = LoadingService(context);
    ToastService toastService = ToastService(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
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
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 25,
            top: 10,
          ),
          child: Column(
            children: [
              Container(
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
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Stack(
                              children: [
                                profile != null
                                    ? CircleAvatar(
                                        radius: 48,
                                        backgroundImage: FileImage(profile!),
                                      )
                                    : const CircleAvatar(
                                        radius: 48,
                                        child: Icon(
                                          Icons.group,
                                          color: Colors.black,
                                          size: 50,
                                        ),
                                      ),
                                Positioned(
                                  right: 0,
                                  bottom: 8,
                                  child: InkWell(
                                    onTap: () async {
                                      final XFile? image =
                                          await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      if (image == null) return;
                                      setState(() {
                                        profile = File(image.path);
                                      });
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
                          const SizedBox(height: 10),
                          const Text(
                            'Conversation name',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                name = value.trim();
                              });
                            },
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 18),
                              hintText: 'Add conversation name',
                              labelText: 'Conversation name',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                  color: Color(0xFFDFDFDF),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                  color: Color(0xFF1455A9),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Private',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                inactiveTrackColor:
                                    const Color(0xFF84AFEF).withOpacity(0.1),
                                value: private,
                                onChanged: (value) {
                                  setState(() {
                                    private = value;
                                  });
                                },
                                activeColor: const Color(0XFF002E58),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: authService.getUsers(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error fetching users'),
                              );
                            }
                            if (snapshot.data == null ||
                                snapshot.data!.docs.isEmpty ) {
                              return const Center(
                                child: Text('No users found'),
                              );
                            }
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  SpartanUser spartanUser =
                                      SpartanUser.fromJson({
                                    'id': snapshot.data!.docs[index].id,
                                    ...snapshot.data!.docs[index].data(),
                                  });

                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        if (selectedUsers
                                            .contains(spartanUser.id)) {
                                          selectedUsers.remove(spartanUser.id);
                                        } else {
                                          selectedUsers.add(spartanUser.id);
                                        }
                                      });
                                    },
                                    title: Text(
                                      spartanUser.fullname,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    subtitle: Text(
                                      spartanUser.email,
                                      style: const TextStyle(
                                        color: Color(0XFF707070),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing: SvgPicture.asset(
                                        selectedUsers.contains(spartanUser.id)
                                            ? 'assets/icons/checked.svg'
                                            : 'assets/icons/circle.svg'),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          spartanUser.profile != null
                                              ? NetworkImage(
                                                  spartanUser.profile!,
                                                )
                                              : null,
                                      child: spartanUser.profile == null
                                          ? SvgPicture.asset(
                                              'assets/icons/profile/profile_outlined.svg',
                                              width: 50,
                                              height: 50,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedUsers.isEmpty || name.isEmpty
                          ? const Color(0XFF93CACA)
                          : const Color(0xFF0C3D6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      minimumSize: const Size(
                        double.infinity,
                        40,
                      ),
                    ),
                    onPressed: () async {
                      if (selectedUsers.isEmpty || name.isEmpty) {
                        return;
                      }

                      try {
                        loadingService.show();
                        selectedUsers.add(auth.currentUser!.uid);
                        await ChatService.createRoom(
                          Room(
                            name: name,
                            createdAt: DateTime.now(),
                            private: private,
                            group: true,
                            invitedIds: selectedUsers,
                          ),
                        );
                        toastService.showSuccessToast('Conversation created');
                        GoRouter.of(context).push('/chat');
                      } catch (error) {
                        String errorMessage = displayErrorMessage(error);
                        toastService.showErrorToast(errorMessage);
                      } finally {
                        loadingService.hide();
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

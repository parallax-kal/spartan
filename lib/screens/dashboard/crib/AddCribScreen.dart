import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Crib.dart';
import 'package:spartan/models/Log.dart';
import 'package:spartan/notifiers/CurrentCribIdNotifier.dart';
import 'package:spartan/services/crib.dart';
import 'package:spartan/services/log.dart';
import 'package:spartan/services/toast.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddCribScreen extends StatefulWidget {
  final Crib? crib;
  const AddCribScreen({super.key, this.crib});

  @override
  State<AddCribScreen> createState() => _AddCribScreenState();
}

class _AddCribScreenState extends State<AddCribScreen> {
  late StringTagController _stringTagController;
  late TextEditingController _nameController;
  List<Map<String, dynamic>> accesses = [];

  String renderStatus(ACCESSSTATUS? status) {
    if (status == null) {
      return '+ Role';
    }
    return status.name.substring(0, 1).toUpperCase() +
        status.name.substring(1).toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.crib?.name ?? '',
    );
    accesses = widget.crib?.access.map((access) {
          return {
            'user': access.user,
            'status': access.status,
          };
        }).toList() ??
        [];
    _stringTagController = StringTagController();
    _stringTagController.addListener(() {
      accesses = _stringTagController.getTags!.map((email) {
        final access = accesses.firstWhere(
          (element) => element['user'] == email,
          orElse: () => {
            'user': email,
            'accepted': false,
          },
        );
        return access;
      }).toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stringTagController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastService toastService = ToastService(context);

    CurrentCribIdNotifier currentCribIdNotifier =
        Provider.of<CurrentCribIdNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          '${widget.crib != null ? 'Edit' : 'Add'} device',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name of crib',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  hintText: 'Type a name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Color(0xFFDFDFDF), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Color(0xFF1455A9), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Grant Access',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              TextFieldTags<String>(
                textfieldTagsController: _stringTagController,
                textSeparators: const [' ', ','],
                initialTags:
                    widget.crib?.access.map((access) => access.user).toList(),
                letterCase: LetterCase.normal,
                validator: (String email) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(email)) {
                    return 'Invalid email';
                  } else if (email == auth.currentUser!.email) {
                    return 'You can\'t add your own email';
                  } else if (_stringTagController.getTags!.contains(email)) {
                    return 'You\'ve already added this email';
                  }

                  return null;
                },
                inputFieldBuilder: (context, inputFieldValues) {
                  return GestureDetector(
                    onTap: () {
                      _stringTagController.getFocusNode?.requestFocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF8E8E8E),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          for (String email in inputFieldValues.tags)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0XFFD9D9D9),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Text(
                                            email,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            child: const Icon(
                                              Icons.cancel_outlined,
                                              size: 14.0,
                                            ),
                                            onTap: () {
                                              inputFieldValues
                                                  .onTagRemoved(email);
                                              setState(() {
                                                accesses.removeWhere((access) =>
                                                    access['user'] == email);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    PopupMenuButton<ACCESSSTATUS>(
                                      color: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem(
                                            value: ACCESSSTATUS.OPERATOR,
                                            child: Text('Operator'),
                                          ),
                                          const PopupMenuItem(
                                            value: ACCESSSTATUS.GUEST,
                                            child: Text('Guest'),
                                          ),
                                        ];
                                      },
                                      onSelected: (ACCESSSTATUS value) {
                                        setState(() {
                                          final access = accesses.firstWhere(
                                              (element) =>
                                                  element['user'] == email);
                                          access['status'] = value;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF000000)
                                                  .withOpacity(0.1),
                                              offset: const Offset(0, 4),
                                              blurRadius: 7.3,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          renderStatus(accesses.firstWhere(
                                              (element) =>
                                                  element['user'] ==
                                                  email)['status']),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          TextField(
                            controller: inputFieldValues.textEditingController,
                            focusNode: inputFieldValues.focusNode,
                            onChanged: inputFieldValues.onTagChanged,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: inputFieldValues.tags.isNotEmpty
                                  ? ''
                                  : "Enter emails...",
                              errorText: inputFieldValues.error,
                            ),
                            onSubmitted: inputFieldValues.onTagSubmitted,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      GoRouter.of(context).push('/stream');
                    },
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: Color(0XFF002E58), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: const Size(103, 32),
                    ),
                    child: const Text(
                      'Skip for later',
                      style: TextStyle(
                        color: Color(0XFF002E58),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C3D6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: const Size(87, 32),
                    ),
                    onPressed: () async {
                      try {
                        String name = _nameController.text.trim();
                        if (name.isEmpty) {
                          toastService.showErrorToast('Please add a name');
                          return;
                        }
                        if (accesses.isEmpty) {
                          toastService.showErrorToast('Please add emails');
                          return;
                        }

                        for (var access in accesses) {
                          if (!access.containsKey('status')) {
                            toastService.showErrorToast('Please add roles');
                            return;
                          }
                        }

                        if (currentCribIdNotifier.cribId == null) {
                          toastService.showErrorToast('Error adding crib');
                          return;
                        }

                        List<Access> accessList = accesses
                            .map((access) => Access(
                                  user: access['user'],
                                  status: access['status'] == 'Operator'
                                      ? ACCESSSTATUS.OPERATOR
                                      : ACCESSSTATUS.GUEST,
                                ))
                            .toList();
                        await CribService.updateCrib(
                            currentCribIdNotifier.cribId!, {
                          'name': _nameController.text,
                          'access': FieldValue.arrayUnion(
                            accessList
                                .map(
                                  (access) => access.toJson(),
                                )
                                .toList(),
                          ),
                        });
                        String message = '';
                        if (name.isNotEmpty) {
                          message = 'Updated crib $name';
                        }
                        if (accesses.isNotEmpty) {
                          if (message.isNotEmpty) {
                            message += ' and ';
                          } else {
                            message = 'Updated';
                          }
                          message += ' access to ${accesses.length} users';
                        }
                        await LogService.addUserLog(
                          Log(
                            title: 'Updated Crib',
                            description: message,
                            createdAt: DateTime.now(),
                          ),
                        );
                        GoRouter.of(context).push('/stream');
                        toastService
                            .showSuccessToast('Crib added successfully!');
                      } catch (error) {
                        toastService.showErrorToast('Error adding crib');
                      }
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Color(0XFFF3F6FC),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

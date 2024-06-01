import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Crib.dart';
import 'package:spartan/services/crib.dart';
import 'package:popover/popover.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/toast.dart';
import 'package:http/http.dart' as http;

class StreamScreen extends StatefulWidget {
  const StreamScreen({super.key});

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3E3E3).withOpacity(0.51),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: "Search",
                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(3),
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3E3E3).withOpacity(0.51),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.black,
                    dividerHeight: 0,
                    unselectedLabelColor: const Color(0xFF515151),
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    indicatorPadding: const EdgeInsets.all(0),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 11,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    tabs: const [
                      Tab(text: "All"),
                      Tab(text: "Active"),
                      Tab(text: "Inactive"),
                      Tab(text: 'Pending'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: SEARCH_STATUS.values.map((status) {
                      return StreamBuilder(
                        stream: CribService.getCribs(status),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Error'));
                          } else if (snapshot.data?.isEmpty ?? true) {
                            return const Center(child: Text('No Cribs'));
                          } else {
                            return SingleChildScrollView(
                              child: Column(
                                children: snapshot.data!.map((crib) {
                                  return CribWidget(
                                    crib: crib,
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CribWidget extends StatelessWidget {
  final Crib crib;

  const CribWidget({super.key, required this.crib});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 15, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.2,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0xFFD2D2D2),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/images/crib.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crib.name ?? 'Crib',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      crib.location == null
                          ? const SizedBox()
                          : Text(
                              "${crib.location?.city} | ${crib.location?.country}",
                              style: const TextStyle(
                                color: Color(0xFF454545),
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    crib.status == STATUS.ACTIVE ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: crib.status == STATUS.ACTIVE
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                crib: crib,
              ),
              const SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Access : ${crib.access.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Color(0xFF0085FF),
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(crib.createdAt),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Crib crib;

  const CustomButton({super.key, required this.crib});

  @override
  Widget build(BuildContext context) {
    bool showAcceptPopover = crib.access.every((access) =>
        access.user != auth.currentUser!.email ||
        (access.accepted != true && access.status != ACCESSSTATUS.ADMIN));
    return GestureDetector(
      child: const Icon(Icons.more_vert),
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => showAcceptPopover
              ? UnAcceptedPopover(
                  crib: crib,
                  context: context,
                )
              : AcceptedPopover(
                  crib: crib,
                  context: context,
                ),
          direction: PopoverDirection.bottom,
          width: 100,
          height: showAcceptPopover ? 80 : 100,
        );
      },
    );
  }
}

class UnAcceptedPopover extends StatelessWidget {
  final Crib crib;
  final BuildContext context;
  const UnAcceptedPopover(
      {super.key, required this.crib, required this.context});

  @override
  Widget build(BuildContext context) {
    LoadingService loadingService = LoadingService(context);
    ToastService toastService = ToastService(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () async {
              try {
                loadingService.show();
                List<Map<String, dynamic>> accesses =
                    crib.access.map((access) => access.toJson()).toList();

                for (var access in accesses) {
                  if (access['user'] == auth.currentUser!.email) {
                    access['accepted'] = true;
                  }
                }

                await CribService.updateCrib(crib.id, {
                  'access': accesses,
                  'users': FieldValue.arrayUnion([auth.currentUser!.uid]),
                });
                toastService.showSuccessToast('Crib accepted');
              } catch (error) {
                toastService.showErrorToast(
                  'Error while accepting crib',
                );
              } finally {
                loadingService.hide();
                Navigator.pop(context);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Accept',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.task_alt,
                  color: Color(0xFF008F39),
                  size: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Divider(
            height: 2,
            color: Color(0xFFEBEBEB),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              try {
                loadingService.show();
                await CribService.deleteCrib(crib);
                toastService.showSuccessToast('Crib denied');
              } catch (error) {
                toastService.showErrorToast(
                  'Error while deleting crib',
                );
              } finally {
                loadingService.hide();
                Navigator.pop(context);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deny',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.visibility,
                  color: Colors.red,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AcceptedPopover extends StatelessWidget {
  final Crib crib;
  final BuildContext context;
  const AcceptedPopover({super.key, required this.crib, required this.context});

  @override
  Widget build(BuildContext context) {
    LoadingService loadingService = LoadingService(context);
    ToastService toastService = ToastService(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          crib.access.any((access) =>
                  access.user == auth.currentUser!.email &&
                  access.status == ACCESSSTATUS.GUEST)
              ? const SizedBox()
              : InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    GoRouter.of(context).push('/crib/add', extra: crib);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.border_color_outlined,
                        color: Color(0xFF0085FF),
                        size: 18,
                      ),
                    ],
                  ),
                ),
          const SizedBox(height: 4),
          const Divider(
            height: 2,
            color: Color(0xFFEBEBEB),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              if (crib.status == STATUS.ACTIVE) {
                try {
                  await http
                      .get(Uri.parse('http://${crib.ipaddress}:8000/check'));
                  GoRouter.of(context).push('/stream/preview', extra: crib);
                } catch (error) {
                  await CribService.updateCrib(crib.id, {
                    'status': 'INACTIVE',
                  });
                  toastService.showErrorToast('Crib is inactive');
                  Navigator.pop(context);
                }
              } else {
                toastService.showErrorToast('Crib is inactive');
                Navigator.pop(context);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preview',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.visibility,
                  color: Color(0xFF008F39),
                  size: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Divider(
            height: 2,
            color: Color(0xFFEBEBEB),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () async {
              try {
                loadingService.show();
                await CribService.deleteCrib(crib);
                toastService.showSuccessToast('Crib deleted');
              } catch (error) {
                toastService.showErrorToast(
                  'Error while deleting crib',
                );
              } finally {
                loadingService.hide();
                Navigator.pop(context);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remove',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

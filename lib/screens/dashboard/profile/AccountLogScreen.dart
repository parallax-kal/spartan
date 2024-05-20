import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Log.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/log.dart';
import 'package:spartan/services/toast.dart';
import 'package:spartan/utils/sort.dart';

class AccountLogScreen extends StatefulWidget {
  const AccountLogScreen({super.key});

  @override
  State<AccountLogScreen> createState() => _AccountLogScreenState();
}

class _AccountLogScreenState extends State<AccountLogScreen> {


  @override
  Widget build(BuildContext context) {
    LoadingService loadingService = LoadingService(context);
    ToastService toastService = ToastService(context);
    return Scaffold(
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
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    titlePadding: const EdgeInsets.all(0),
                    contentPadding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 7.3,
                    shadowColor: const Color(0xFF000000).withOpacity(0.4),
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 35,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'You are about to delete logs from your Spartan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Do you wish to continue?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF969696),
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            try {
                              loadingService.show();
                              await LogService.deleteAllUserLogs();
                              Navigator.of(context).pop();
                              toastService.showSuccessToast(
                                'Logs deleted successfully',
                              );
                            } catch (error) {
                              String errorMessage =
                                  displayErrorMessage(error);
                              toastService.showErrorToast(errorMessage);
                            } finally {
                              loadingService.hide();
                            }
                          },
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              color: Color(0XFF7ABFFF),
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_forever_outlined),
          )
        ],
      ),
      body: Column(
        children: [
          const Text(
            'Account Log',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: StreamBuilder(
              stream: LogService.getUserLog(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                  case ConnectionState.active:
                    if (snapshot.data?.docs.isEmpty ?? true) {
                      return const Center(
                        child: Text('No Logs'),
                      );
                    }
                    List<Log> logs = snapshot.data!.docs
                        .map((e) => Log.fromJson(e.data()))
                        .toList();
                    List<Map<DateTime, List<Log>>> sortedLogs = sortItems(logs);
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        child: Column(
                          children: sortedLogs.map(
                            (sortedLog) {
                              DateTime wholeday = sortedLog.keys.first;
                              List<Log> logs = sortedLog.values.first;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat(
                                      'd MMM${wholeday.year != DateTime.now().year ? ' yyyy' : ''}',
                                    ).format(wholeday),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Column(
                                    children: logs.map(
                                      (log) {
                                        return Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFF84AFEF)
                                                            .withOpacity(0.3),
                                                    offset: const Offset(0, 4),
                                                    blurRadius: 24,
                                                    spreadRadius: 0,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.circle,
                                                        color:
                                                            Color(0XFF0085FF),
                                                        size: 10,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            log.title,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            log.description,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0XFF929292),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 10,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    DateFormat('h:mm a')
                                                        .format(log.createdAt),
                                                    style: const TextStyle(
                                                      color: Color(0XFF929292),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 13,
                                            ),
                                          ],
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

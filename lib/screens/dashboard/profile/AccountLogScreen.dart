import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Log.dart';
import 'package:spartan/services/loading.dart';
import 'package:spartan/services/log.dart';
import 'package:spartan/services/toast.dart';

class AccountLogScreen extends StatefulWidget {
  const AccountLogScreen({super.key});

  @override
  State<AccountLogScreen> createState() => _AccountLogScreenState();
}

class _AccountLogScreenState extends State<AccountLogScreen> {
  List<Map<DateTime, List<Log>>> sortLogs(List<Log> logs) {
    Map<DateTime, List<Log>> sortedMessages = {};

    for (Log log in logs) {
      DateTime logDate = log.createdAt;
      DateTime logDay = DateTime(logDate.year, logDate.month, logDate.day);

      if (sortedMessages.containsKey(logDay)) {
        sortedMessages[logDay]!.add(log);
      } else {
        sortedMessages[logDay] = [log];
      }
    }

    List<Map<DateTime, List<Log>>> sortedList = [];

    sortedMessages.forEach((key, value) {
      sortedList.add({key: value});
    });

    return sortedList;
  }

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
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                loadingService.show();
                await LogService.deleteAllUserLogs();
                loadingService.hide();
                // toastService.showSuccessToast('Logs deleted successfully');
              } catch (error) {
                String errorMessage = displayErrorMessage(error as Exception);
                // toastService.showErrorToast(errorMessage);
              } finally {}
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
                    List<Map<DateTime, List<Log>>> sortedLogs = sortLogs(logs);
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

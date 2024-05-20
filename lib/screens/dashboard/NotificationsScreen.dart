import 'package:flutter/material.dart';
import 'package:spartan/services/notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Expanded(
          child: StreamBuilder(
              stream: NotificationService.getNotifications(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (snapshot.data?.isEmpty ?? true) {
                      return const Center(
                        child: Text('No notifications'),
                      );
                    }
                    return SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                            return ListTile(
                            title: Text(snapshot.data![index].title),
                            subtitle: Text(snapshot.data![index].body),
                            leading:  CircleAvatar(
                              backgroundImage: 
                              snapshot.data![index] == null ? null : 
                              NetworkImage(snapshot.data![index].image!),
                            child: SvgPicture.asset('assets/icons/notifications.svg')
                            ),
                            );
                        },
                      ),
                    );
                }
              }),
        ),
      ),
    );
  }
}

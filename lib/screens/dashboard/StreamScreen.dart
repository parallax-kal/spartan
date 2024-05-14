import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spartan/services/crib.dart';

class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 32,
          right: 32,
        ),
        child: Expanded(
          child: StreamBuilder(
            stream: CribService.getCribs(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text('No cribs found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final crib = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(crib['name']),
                        subtitle: Text(crib['status'] ? 'Online' : 'Offline'),
                        onTap: () {
                          context.go('/stream/${crib['id']}');
                        },
                      );
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

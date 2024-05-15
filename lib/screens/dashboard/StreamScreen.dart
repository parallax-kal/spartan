import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spartan/models/Crib.dart';
import 'package:spartan/services/crib.dart';

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
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0XFFE3E3E3).withOpacity(0.51),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: "Search",
                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none, // Remove the border here
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 3,
                  ),
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0XFFE3E3E3).withOpacity(0.51),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.black,
                    dividerHeight: 0,
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
                      Tab(
                        text: "All",
                      ),
                      Tab(
                        text: "Active",
                      ),
                      Tab(
                        text: "Inactive",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SEARCH_STATUS.ALL,
                      SEARCH_STATUS.ACTIVE,
                      SEARCH_STATUS.INACTIVE
                    ].map((search_status) {
                      return StreamBuilder(
                        stream: CribService.getCribs(search_status),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text('Error'),
                            );
                          } else if (snapshot.data?.docs.isEmpty ?? true) {
                            return const Center(
                              child: Text('No Cribs'),
                            );
                          } else {
                            List<Crib> cribs = snapshot.data!.docs
                                .map((e) => Crib.fromJson({
                                      'id': e.id,
                                      ...e.data(),
                                    }))
                                .toList();
                            return SingleChildScrollView(
                              child: Column(
                                children: cribs.map((crib) {
                                  return CribCard(crib: crib);
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

class CribCard extends StatefulWidget {
  final Crib crib;

  const CribCard({super.key, required this.crib});

  @override
  State<CribCard> createState() => _CribCardState();
}

class _CribCardState extends State<CribCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 5,
      ),
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
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.crib.name ?? 'Crib',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "${widget.crib.location.city} | ${widget.crib.location.country}",
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
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  const Text('Status',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      )),
                  const SizedBox(width: 5),
                  Text(
                    widget.crib.status == STATUS.ACTIVE ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: widget.crib.status == STATUS.ACTIVE
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
              const Icon(Icons.more_vert),
              const SizedBox(height: 14,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Access : ${widget.crib.access.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Color(0xFF0085FF),
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(widget.crib.createdAt),
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

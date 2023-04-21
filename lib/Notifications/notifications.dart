// ignore_for_file: avoid_print, unused_local_variable
import 'package:Nilinde/components/nodata.dart';
import 'package:Nilinde/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import 'package:grouped_list/grouped_list.dart';
import "package:calendar_time/calendar_time.dart";
import 'package:get/get.dart';

final user = FirebaseAuth.instance.currentUser!;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> notificationsStream =
        FirebaseFirestore.instance.collection("/notifications").snapshots();

        FirebaseFirestore.instance.collection("users").get()
          .then((value){
          print("notificationsStreamnotificationsStream:${value.docs.length}");
        });
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: notificationsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.orange),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            } else {
              List<QueryDocumentSnapshot> dataList = snapshot.data!.docs;
              print("DATAAAAAAAA:$dataList");
              if (dataList.isEmpty) {
                return const Nodata(message: "No new notification(s) found.");
              }
              return buildList(context, dataList);
            }
          }),
    );
  }
}

Widget buildList(BuildContext context, data) {
  return GroupedListView<dynamic, String>(
    elements: data,
    groupBy: (element) => (CalendarTime(element['Date'].toDate()).isToday
            ? "Today"
            : (CalendarTime(element['Date'].toDate()).isYesterday
                ? "Yesterday"
                : DateFormat.MMMMEEEEd().format(element['Date'].toDate())))
        .toUpperCase(),
    groupSeparatorBuilder: (String groupByValue) => Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              groupByValue,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          )
        ],
      ),
    ),
    itemBuilder: (context, dynamic element) {
      return createList(context, element);
    },
    itemComparator: (item1, item2) => item1['Date']
        .toDate()
        .toString()
        .compareTo(item2['Date'].toDate().toString()), // optional
    useStickyGroupSeparators: true, // optional
    floatingHeader: true, // optional
    order: GroupedListOrder.ASC, // optional
  );
}

Widget createList(context, data) {
  var isRead = data['IsRead'];
  var time = DateFormat("hh:mm:a").format(data['Date'].toDate());
  return Slidable(
    startActionPane: ActionPane(motion: const StretchMotion(), children: [
      SlidableAction(
        backgroundColor: Colors.greenAccent,
        icon: Ionicons.map_outline,
        label: "View Maps",
        onPressed: (context) {
          Get.to(() => const MapsScreen());
        },
      )
    ]),
    endActionPane: ActionPane(motion: const StretchMotion(), children: [
      SlidableAction(
        backgroundColor: Colors.greenAccent,
        icon: Ionicons.map_outline,
        label: "View maps",
        onPressed: (context) {
          Get.to(() => const MapsScreen());
        },
      )
    ]),
    child: Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          title: Text("${data['FullName']}".toUpperCase(),
              style: TextStyle(fontWeight: !isRead ? FontWeight.bold : null)),
          subtitle: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: data['Location'],
                style: const TextStyle(color: Colors.black, fontSize: 13),
              )),
          leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(data['FullName'][0].toUpperCase(),style: const TextStyle(color: Colors.white)),),
          dense: false,
          trailing: Text(time, style: const TextStyle(color: Colors.grey)),
          onTap: () {
            //acceptResponse(context, data.id);
          },
        ),
      ),
    ),
  );
}

acceptResponse(BuildContext context, messageId) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("Confirm action"),
      content: const Text("Confirm accepting to respond?"),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Ok'),
          onPressed: () async {},
        ),
      ],
    ),
  );
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Card(
      color: Colors.red,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: query.isNotEmpty
            ? FirebaseFirestore.instance
                .collection("notifications")
                .where('indexKey', arrayContains: query.toLowerCase())
                .snapshots()
            : FirebaseFirestore.instance
                .collection("notifications")
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.orange),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          } else {
            final snap = snapshot.data!.docs;
            if (snap.isEmpty) {
              return const Nodata(message: "No results found.");
            }
            return createList(context, snap);
          }
        });
  }
}

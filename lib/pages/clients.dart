import 'package:Nilinde/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Nilinde/components/nodata.dart';
import 'package:ionicons/ionicons.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final Stream<QuerySnapshot> clientsStream = FirebaseFirestore.instance
      .collection("/users")
      .where("Client", isEqualTo: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
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
        stream: clientsStream,
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
            List<QueryDocumentSnapshot> dataList = snapshot.data!.docs;
            if (dataList.isEmpty) {
              return const Nodata(message: "No clients found.");
            }
            return buildList(context, dataList);
          }
        },
      ),
    );
  }
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
                .collection("users")
                .where('indexKey', arrayContains: query.toLowerCase())
                .snapshots()
            : FirebaseFirestore.instance
                .collection("users")
                .where("Client", isEqualTo: true)
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
            return buildList(context, snap);
          }
        });
  }
}

Widget buildList(context, data) {
  final themedata = GetStorage();
  bool isDarkMode = themedata.read("darkmode") ?? false;

  return ListView.builder(
    itemCount: data.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, index) {
      return  Card(
        elevation: 5.0,
        child: ListTile(
          title: Text(data[index]['FirstName']),
          subtitle: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: data[index]['Email'],
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: AppColors.kPrimaryColor,
            child: Text(data[index]['FirstName'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white)),
          ),
          dense: false,
          trailing: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Ionicons.person_sharp,
                size: 24.0,
                color: AppColors.kPrimaryColor,
              ),
            ),
          ),
        ),
      );
    },
  );
}

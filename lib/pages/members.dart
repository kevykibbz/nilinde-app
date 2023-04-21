import 'package:Nilinde/pages/clients.dart';
import 'package:Nilinde/pages/employees.dart';
import 'package:flutter/material.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<Tab> tabs = [
    const Tab(
      child: Text("Employees"),
    ),
    const Tab(
      child: Text("Clients"),
    ),
  ];

  List<Widget> tabContent = [
    const EmployeesPage(),
    const ClientsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Members",
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 3,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: <Color>[
          //         Theme.of(context).primaryColor,
          //         Theme.of(context).colorScheme.secondary,
          //       ],
          //     ),
          //   ),
          // ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: TabBar(
              labelPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicatorWeight: 2,
              isScrollable: true,
              tabs: tabs,
            ),
          ),
        ),
        body: TabBarView(
          children: tabContent,
        ),
      ),
    );
  }
}

import 'package:Nilinde/config/config.dart';
import 'package:Nilinde/mixin/shutdown.dart';
import 'package:Nilinde/pages/change_password.dart';
import 'package:Nilinde/pages/firebase/firebaseauth.dart';
import 'package:Nilinde/Notifications/notifications.dart';
import 'package:Nilinde/pages/members.dart';
import 'package:Nilinde/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with AppCloser {
  double drawerIconSize = 24;
  double drawerFontSize = 17;

  List<Tab> tabs = [
    const Tab(
      child: Text("Dashboard"),
    ),
    const Tab(
      child: Text("Profile"),
    ),
  ];

  List<Widget> tabContent = [
    const NotificationScreen(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.warning_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const Expanded(child: Text("Warning")),
                    ]),
                content: const Text('Do you wish to exit Nilinde ?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      closeApp();
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Dashboard",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
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
            drawer: Drawer(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.2),
                      Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                    ],
                  ),
                ),
                child: ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.0, 1.0],
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: const Text(
                          MyConfig.appName,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        size: drawerIconSize,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(
                        'Members',
                        style: TextStyle(
                            fontSize: drawerFontSize,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MembersScreen()),
                        );
                      },
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      height: 1,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.password_rounded,
                        size: drawerIconSize,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(
                        'Change password',
                        style: TextStyle(
                            fontSize: drawerFontSize,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () {
                        Get.to(() => const ChangePasswordScreen());
                      },
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      height: 1,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout_rounded,
                        size: drawerIconSize,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: drawerFontSize,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () {
                        AuthRepository.instance.logout(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: tabContent,
            )),
      ),
    );
  }
}

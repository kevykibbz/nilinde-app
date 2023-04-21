import 'package:flutter/material.dart';



class NotificaionScreen extends StatefulWidget {
  const NotificaionScreen({super.key});

  @override
  State<NotificaionScreen> createState() => _NotificaionScreenState();
}

class _NotificaionScreenState extends State<NotificaionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child:Text("Notifications page"));
  }
}
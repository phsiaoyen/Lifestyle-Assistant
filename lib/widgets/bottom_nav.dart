import 'package:flutter/material.dart';

import 'package:test_dart/widgets/schedules.dart';
import 'package:test_dart/widgets/setting.dart';
import 'package:test_dart/widgets/foods.dart';
import 'package:test_dart/widgets/chat.dart';
import 'user.dart';

class MyTabs extends StatefulWidget {
  final User user;
  //final String foodHistory;
  //final ValueChanged<bool> onDarkModeChanged;
  const MyTabs({/*required this.onDarkModeChanged,*/ required this.user, super.key});
  //final ValueChanged<User> transferUser;
  @override
  State<MyTabs> createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  late TabController _controller;
  late List<String> _chatHistory;
  //User _user;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);
    _chatHistory = [];
    //_user = User();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: PageStorageBucket(),
        child: TabBarView(
          controller: _controller,
          children: [
            PageStorage(
              bucket: PageStorageBucket(),
              child: const Schedules(),
            ),
            PageStorage(
              bucket: PageStorageBucket(),
              child: const Foods(),
            ),

            PageStorage(
              bucket: PageStorageBucket(),
              child: SettingScreen(user:widget.user/*,onDarkModeChanged: widget.onDarkModeChanged*/),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TabBar(
        controller: _controller,
        tabs: const [
          Tab(text: 'Home',icon: Icon(Icons.home),),
          Tab(text: 'Diet',icon: Icon(Icons.fastfood),),
          Tab(text: 'Profile',icon: Icon(Icons.person),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPage(history: _chatHistory)),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
  
}

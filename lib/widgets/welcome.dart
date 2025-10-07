import 'package:flutter/material.dart';
import 'package:test_dart/widgets/create_account_screen.dart';
import 'package:test_dart/widgets/bottom_nav.dart';
import 'user.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).dividerColor,
              radius: 100,
              child: const Icon(
                Icons.accessibility_new_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const CreateAccountScreen();
                  },
                );
              },
              child: const Text("Sign in"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                User user = User();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                      return MyTabs(user: user); 
                    },
                    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text("log in"),
            ),
          ],
        ),
      ),
    );
  }
}

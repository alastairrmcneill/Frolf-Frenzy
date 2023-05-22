import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ript_revenge/notifiers/notifiers.dart';
import 'package:ript_revenge/services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Screen'),
            Text(userNotifier.currentUser?.name ?? 'null'),
            ElevatedButton(
              onPressed: () async {
                await AuthService.signOut(context);
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}

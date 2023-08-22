import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ript_revenge/notifiers/notifiers.dart';
import 'package:ript_revenge/services/services.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(userNotifier.currentUser?.name ?? 'Name'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.signOut(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                GameService.createGame(context);
              },
              child: Text('New Game'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Join Game'),
            ),
          ],
        ),
      ),
    );
  }
}

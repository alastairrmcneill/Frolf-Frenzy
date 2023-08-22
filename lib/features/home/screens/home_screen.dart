import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ript_revenge/features/game/screens/game_screen.dart';
import 'package:ript_revenge/features/home/screens/screens.dart';
import 'package:ript_revenge/models/models.dart';
import 'package:ript_revenge/services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    UserDatabase.readCurrentUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    // return StreamProvider<Game?>.value(
    //   value: GameDatabase.gameStream(user!.uid),
    //   initialData: null,
    //   catchError: (context, error) {
    //     print(error);
    //   },
    //   child: Consumer<Game?>(
    //     builder: (context, value, child) {
    //       if (value == null) {
    //         return MainMenuScreen();
    //       }
    //       return GameScreen();
    //     },
    //   ),
    // );

    return StreamBuilder<Game>(
      stream: GameDatabase.gameStream(user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return MainMenuScreen();
        }
        return GameScreen(game: snapshot.data!);
      },
    );
  }
}

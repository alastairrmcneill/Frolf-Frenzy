import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ript_revenge/models/models.dart';
import 'package:ript_revenge/notifiers/notifiers.dart';
import 'package:ript_revenge/services/services.dart';
import 'package:ript_revenge/widgets/widgets.dart';

class GameService {
  static Future createGame(BuildContext context) async {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
    Game game = Game(hostUid: userNotifier.currentUser!.uid!);

    await GameDatabase.create(context, game: game);
  }

  static Future endGame(BuildContext context, {required Game game}) async {
    final user = Provider.of<User?>(context, listen: false);

    if (user == null) return;

    if (user.uid == game.hostUid) {
      await GameDatabase.deleteGame(context, uid: game.uid!);
    }
  }
}

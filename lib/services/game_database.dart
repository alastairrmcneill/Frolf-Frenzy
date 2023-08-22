import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ript_revenge/models/models.dart';
import 'package:ript_revenge/widgets/widgets.dart';

class GameDatabase {
  static final _db = FirebaseFirestore.instance;
  static final CollectionReference _gamesRef = _db.collection('games');

  static Future create(BuildContext context, {required Game game}) async {
    DocumentReference _ref = _gamesRef.doc();

    game.uid = _ref.id;

    await _ref.set(game.toJSON());
  }

  static Stream<Game> gameStream(String hostUid) {
    return _gamesRef.where(GameFields.hostUid, isEqualTo: hostUid).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Game.fromJSON(doc.data()),
              )
              .toList()[0],
        );
  }

  static deleteGame(BuildContext context, {required String uid}) async {
    try {
      await _gamesRef.doc(uid).delete();
    } on FirebaseException catch (error) {
      showErrorDialog(context, message: error.message ?? 'There was an error deleting your game.');
    }
  }
}

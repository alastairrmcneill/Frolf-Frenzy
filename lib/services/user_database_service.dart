import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ript_revenge/models/models.dart';
import 'package:ript_revenge/notifiers/notifiers.dart';
import 'package:ript_revenge/services/services.dart';
import 'package:ript_revenge/widgets/widgets.dart';

class UserDatabase {
  static final _db = FirebaseFirestore.instance;
  static final CollectionReference _userRef = _db.collection('users');

  // Create user
  static Future create(BuildContext context, {required AppUser appUser}) async {
    try {
      DocumentReference ref = _userRef.doc(appUser.uid);

      await ref.set(appUser.toJSON());
    } on FirebaseException catch (error) {
      showErrorDialog(context, message: error.message ?? "There was an error creating your account.");
    }
  }

  // Read specific user
  static Future<AppUser?> readUserWithUID(BuildContext context, {required String uid}) async {
    try {
      DocumentReference ref = _userRef.doc(uid);
      DocumentSnapshot documentSnapshot = await ref.get();

      if (!documentSnapshot.exists) return null;

      Map<String, Object?> data = documentSnapshot.data() as Map<String, Object?>;

      AppUser appUser = AppUser.fromJSON(data);
      return appUser;
    } on FirebaseException catch (error) {
      showErrorDialog(context, message: error.message ?? "There was an error fetching account $uid.");
      return null;
    }
  }

  // Read current user
  static Future readCurrentUser(BuildContext context) async {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);

    try {
      String? uid = AuthService.currentUserId;

      if (uid == null) return;

      DocumentReference ref = _userRef.doc(uid);
      DocumentSnapshot documentSnapshot = await ref.get();

      if (!documentSnapshot.exists) return;

      Map<String, Object?> data = documentSnapshot.data() as Map<String, Object?>;

      AppUser appUser = AppUser.fromJSON(data);
      userNotifier.setCurrentUser = appUser;
    } on FirebaseException catch (error) {
      showErrorDialog(context, message: error.message ?? "There was an error fetching your account.");
    }
  }

  // Update user
  static Future update(BuildContext context, {required AppUser appUser}) async {
    try {
      DocumentReference ref = _userRef.doc(appUser.uid);

      await ref.update(appUser.toJSON());
    } on FirebaseException catch (error) {
      showErrorDialog(context, message: error.message ?? "There was an error updating your account.");
    }
  }

  // Delete user
  static Future deleteUserWithUID(BuildContext context, {required String uid}) async {
    try {
      DocumentReference ref = _userRef.doc(uid);

      await ref.delete();
    } on FirebaseException catch (error) {
      showErrorDialog(context, message: error.message ?? "There was an error deleting your account");
    }
  }
}

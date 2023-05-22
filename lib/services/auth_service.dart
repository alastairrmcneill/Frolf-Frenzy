import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:ript_revenge/models/models.dart';
import 'package:ript_revenge/notifiers/notifiers.dart';
import 'package:ript_revenge/services/services.dart';
import 'package:ript_revenge/support/wrapper.dart';
import 'package:ript_revenge/widgets/widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // User stream
  static Stream<User?> get appUserStream {
    return _auth.authStateChanges();
  }

  // Current user id
  static String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  // Register with email
  static Future registerWithEmail(BuildContext context, {required String email, required String password, required String name}) async {
    showCircularProgressOverlay(context);
    try {
      // Register in Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user == null) return;

      // Update display name
      credential.user!
          .updateDisplayName(
            name,
          )
          .whenComplete(
            () => credential.user!.reload(),
          );

      AppUser appUser = AppUser(
        uid: _auth.currentUser!.uid,
        name: name,
      );
      await UserDatabase.create(context, appUser: appUser);
      await UserDatabase.readCurrentUser(context);

      stopCircularProgressOverlay(context);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);

      showErrorDialog(context, message: error.message ?? 'There was an error with authorisation.');
    }
  }

  // Sign in with email
  static Future signInWithEmail(BuildContext context, {required String email, required String password}) async {
    showCircularProgressOverlay(context);
    try {
      // Login to firebase
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (credential.user == null) return;
      await UserDatabase.readCurrentUser(context);
      stopCircularProgressOverlay(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, message: error.message ?? "There has been an error logging in.");
    }
  }

  // Sign in with google
  static Future signInWithGoogle(BuildContext context) async {
    showCircularProgressOverlay(context);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential credential = await _auth.signInWithCredential(googleCredential);

      if (credential.user == null) return;

      if (_auth.currentUser == null) return;

      List<String> names = _auth.currentUser!.displayName?.split(' ') ?? [''];

      AppUser appUser = AppUser(
        uid: _auth.currentUser!.uid,
        name: names[0],
      );
      await UserDatabase.create(context, appUser: appUser);
      await UserDatabase.readCurrentUser(context);
      stopCircularProgressOverlay(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, message: error.message ?? 'There was an error with Google sign in.');
    }
  }

  // Sign in with apple
  static Future signInWithApple(BuildContext context) async {
    showCircularProgressOverlay(context);
    try {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      OAuthCredential appleCredential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      UserCredential credential = await _auth.signInWithCredential(appleCredential);

      if (credential.user!.displayName == null) {
        await credential.user!
            .updateDisplayName(
          appleIdCredential.givenName ?? "",
        )
            .whenComplete(
          () async {
            await credential.user!.reload();
          },
        );
      }

      if (_auth.currentUser == null) return;

      AppUser appUser = AppUser(
        uid: _auth.currentUser!.uid,
        name: _auth.currentUser!.displayName!,
      );
      await UserDatabase.create(context, appUser: appUser);
      await UserDatabase.readCurrentUser(context);
      stopCircularProgressOverlay(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, message: error.message ?? "There was an error with Apple sign in.");
    } on SignInWithAppleAuthorizationException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, message: error.message);
    }
  }

  // Forgot password
  static Future forgotPassword(BuildContext context, {required String email}) async {
    showCircularProgressOverlay(context);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      stopCircularProgressOverlay(context);
      showSnackBar(context, 'Sent password reset email.');
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, message: error.message ?? 'There was an error with this process.');
    }
  }

  // Sign out
  static Future signOut(BuildContext context) async {
    showCircularProgressOverlay(context);
    try {
      UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
      userNotifier.setCurrentUser = null;

      // if (_googleSignIn.currentUser != null) {
      //   await _googleSignIn.disconnect();
      // }
      await _auth.signOut();
      stopCircularProgressOverlay(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, message: error.message ?? "There was an error deleting your account");
    }
  }

  // Delete account
  static Future delete(BuildContext context) async {
    showCircularProgressOverlay(context);
    try {
      UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);

      userNotifier.setCurrentUser = null;
      await UserDatabase.deleteUserWithUID(context, uid: _auth.currentUser!.uid);
      await _auth.currentUser?.delete();
      stopCircularProgressOverlay(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, message: error.message ?? "There was an error deleting your account");
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ript_revenge/features/home/screens/screens.dart';
import 'package:ript_revenge/features/onbaording/screens/screens.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return const OnboardingScreen();
    } else {
      return const HomeScreen();
    }
  }
}

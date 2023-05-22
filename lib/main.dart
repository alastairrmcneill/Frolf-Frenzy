import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ript_revenge/notifiers/notifiers.dart';
import 'package:ript_revenge/services/services.dart';
import 'package:ript_revenge/support/theme.dart';
import 'package:ript_revenge/support/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService.appUserStream,
          initialData: null,
        ),
        ChangeNotifierProvider<UserNotifier>(
          create: (_) => UserNotifier(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Frenzy',
        debugShowCheckedModeBanner: false,
        theme: MyTheme.theme,
        home: const Wrapper(),
      ),
    );
  }
}

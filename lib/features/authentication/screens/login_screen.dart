import 'package:flutter/material.dart';
import 'package:ript_revenge/services/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login Screen'),
            ElevatedButton(
              onPressed: () async {
                // await AuthService.signInWithEmail(context, email: '1@1.com', password: '123456');
                await AuthService.signInWithApple(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

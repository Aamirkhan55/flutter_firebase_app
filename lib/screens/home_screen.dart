import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/screens/notes_screen.dart';
import 'package:flutter_firebase_app/screens/sign_in.dart';
import 'package:flutter_firebase_app/screens/varify_email.dart';
import 'package:flutter_firebase_app/services/auth/auth_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: FutureBuilder(
          future: AuthServices.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = AuthServices.firebase().currentUser;
                if (user != null) {
                  if (user.isEmailVarified) {
                    'Email Is Varify';
                    return const NoteScreen();
                  } else {
                    return const VarifyEmailScreen();
                  }
                } else {
                  return const SignInScreen();
                }
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

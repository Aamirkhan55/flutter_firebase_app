import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/screens/notes_screen.dart';
import 'package:flutter_firebase_app/screens/sign_up.dart';
import 'package:flutter_firebase_app/screens/varify_email.dart';

import 'constants/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.teal,
    ),
    home: const SignUpScreen(),
    initialRoute: '/SignIn/',
    routes: {
      signInRoute: (context) => const SignUpScreen(),
      signUpRoute: (context) => const SignUpScreen(),
      notesRoute: (context) => const NoteScreen(),
      varifyRoute: (context) => const VarifyEmailScreen(),
    },
  ));
}

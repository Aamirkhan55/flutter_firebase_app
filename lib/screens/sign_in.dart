import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/Utilities/Dialog/error_dailog.dart';
import 'package:flutter_firebase_app/screens/sign_up.dart';
import 'package:flutter_firebase_app/services/auth/auth_exception.dart';
import 'package:flutter_firebase_app/services/auth/auth_services.dart';
import 'package:flutter_firebase_app/widgets/roundButton.dart';
import '../constants/routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController.text.toString();
    _passwordController.text.toString();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SignIn Screen'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 05,
                width: MediaQuery.of(context).size.width * .05,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.teal[400],
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 05,
                width: MediaQuery.of(context).size.width * .05,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: _passwordController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.teal[400],
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Text(
                  "Don't Have An Account?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: const Text(
                    'SignUp',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            RoundButton(
                title: 'SignIn',
                onPress: () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;

                  try {
                    AuthServices.firebase()
                        .signIn(email: email, password: password);
                    final user = AuthServices.firebase().currentUser;
                    if (user?.isEmailVarified ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          notesRoute, (route) => false);
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          varifyRoute, (route) => false);
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDailog(context, 'User Not Found');
                  } on WrongPasswordAuthException {
                    await showErrorDailog(context, 'Wrong Password');
                  } on GenericAuthException {
                    await showErrorDailog(context, 'Authenection Error');
                  }
                }),
          ],
        ));
  }
}

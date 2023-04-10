import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/Utilities/error_dailog.dart';
import 'package:flutter_firebase_app/constants/routes.dart';
import 'package:flutter_firebase_app/screens/sign_in.dart';
import 'package:flutter_firebase_app/services/auth/auth_exception.dart';
import 'package:flutter_firebase_app/services/auth/auth_services.dart';
import 'package:flutter_firebase_app/widgets/roundButton.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
          title: const Text('SignUp Screen'),
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
                  "Already Have An Account?",
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
                            builder: (context) => const SignInScreen()));
                  },
                  child: const Text(
                    'SignIn',
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
                title: 'SignUp',
                onPress: () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  try {
                    AuthServices.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    AuthServices.firebase().sendEmailVarification();
                    Navigator.of(context).pushNamed(varifyRoute);
                  } on WeekPasswordFoundAuthException {
                    showErrorDailog(context, 'Weak Password');
                  } on EmailAlreadyInUseAuthException {
                    showErrorDailog(context, 'Email Aready In Used');
                  } on InvalidEmailAuthException {
                    showErrorDailog(context, 'Invalid Email Adrress');
                  } on GenericAuthException {
                    showErrorDailog(context, 'Failed To Register');
                  }
                }),
          ],
        ));
  }
}

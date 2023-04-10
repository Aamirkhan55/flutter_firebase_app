import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/constants/routes.dart';
import 'package:flutter_firebase_app/services/auth/auth_services.dart';
import '../widgets/roundButton.dart';

class VarifyEmailScreen extends StatefulWidget {
  const VarifyEmailScreen({super.key});

  @override
  State<VarifyEmailScreen> createState() => _VarifyEmailScreenState();
}

class _VarifyEmailScreenState extends State<VarifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Varify Screen'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              'Please Varify Your Email Varification',
            ),
          ),
          RoundButton(
            onPress: () async {
              await AuthServices.firebase().sendEmailVarification();
              
            },
            title: 'Email Varification',
          ),
          RoundButton(
            title: 'Restart',
            onPress: () async {
               AuthServices.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(signUpRoute, (route) => false);
            },
          )
        ],
      ),
    );
  }
}

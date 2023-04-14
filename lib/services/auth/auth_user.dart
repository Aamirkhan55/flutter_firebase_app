import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final String? email;
  final bool isEmailVarified;
  const AuthUser({required this.email, required this.isEmailVarified});

  factory AuthUser.fromFirebase(User user)
   => AuthUser(
    email: user.email,
    isEmailVarified:user.emailVerified,
    );
}

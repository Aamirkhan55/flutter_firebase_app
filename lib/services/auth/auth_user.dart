import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final bool isEmailVarified;
  const AuthUser({required this.isEmailVarified});

  factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVarified:user.emailVerified);
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_app/services/auth/auth_exception.dart';
import 'package:flutter_firebase_app/services/auth/auth_provider.dart';
import 'package:flutter_firebase_app/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLogInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'Weak Password') {
        throw WeekPasswordFoundAuthException();
      } else if (e.code == 'eamil-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() async{
   final user = FirebaseAuth.instance.currentUser;
   if (user != null) {
     await FirebaseAuth.instance.signOut();
   } else {
     throw UserNotLogInAuthException();
   }
  }

  @override
  Future<void> sendEmailVarification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLogInAuthException();
    }
  }

  @override
  Future<AuthUser> signIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLogInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user not found') {
        'User Not Found';
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong password') {
        'Wrong Password';
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
  
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
  }
}

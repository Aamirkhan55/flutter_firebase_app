import 'package:flutter_firebase_app/services/auth/auth_provider.dart';
import 'package:flutter_firebase_app/services/auth/auth_user.dart';
import 'package:flutter_firebase_app/services/auth/firebase_auth_provider.dart';

class AuthServices implements AuthProvider{
  final AuthProvider provider;
  AuthServices(this.provider);

  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password
    }) => provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVarification() => provider.sendEmailVarification();

  @override
  Future<AuthUser> signIn({required String email, required String password}) 
  => provider.signIn(email: email, password: password);
  
  @override
  Future<void> initialize() => provider.initialize();

}
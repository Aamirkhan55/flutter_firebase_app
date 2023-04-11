import 'package:flutter_firebase_app/services/auth/auth_exception.dart';
import 'package:flutter_firebase_app/services/auth/auth_provider.dart';
import 'package:flutter_firebase_app/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authinection', () {
    final provider = MockAuthProvider();

    test('Should Not Be Initialized To Begin With', () {
      expect(provider._isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User Should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Should be initialization in 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate to login function ', () async {
      final badEmailUser =
          provider.createUser(email: 'foo@bar.com', password: 'anypassword');
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPassword =
          provider.createUser(email: 'someone@bar.com', password: 'foobar');
      expect(
          badPassword, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVarified, false);
    });

    test('Logged in user should be able to get varified', () {
      provider.sendEmailVarification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVarified, true);
    });

    test('Should be logout and login again', () async{
      await provider.logOut();
      await provider.signIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

// Test Exception

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return signIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVarification() async {
    if (!_isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVarified: true);
    _user = newUser;
  }

  @override
  Future<AuthUser> signIn({required String email, required String password}) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVarified: false);
    _user = user;
    return Future.value(user);
  }
}

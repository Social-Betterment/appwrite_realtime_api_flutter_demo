import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'environment.dart';

class AuthState extends ChangeNotifier {
  final Account _account;
  final Client _client;
  User? _user;

  AuthState(Client client) : _account = Account(client), _client = client {
    _checkCurrentUser();
  }
  Client get client => _client;
  User? get user => _user;

  Future<void> _checkCurrentUser() async {
    try {
      _user = await _account.get();
      notifyListeners();
    } on AppwriteException {
      _user = null;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    await _account.createEmailPasswordSession(email: email, password: password);
    await _checkCurrentUser();
  }

  Future<void> signup(String email, String password) async {
    await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
    );
    await _account.createVerification(
      url: '${Environment.appBaseUrl}/verify-email',
    );
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
    _user = null;
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    _user = await _account.updateName(name: name);
    notifyListeners();
  }

  Future<void> createRecovery(String email) async {
    await _account.createRecovery(
      email: email,
      url: '${Environment.appBaseUrl}/account-recovery',
    );
  }
}

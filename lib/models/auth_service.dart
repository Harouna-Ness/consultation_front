import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isAuthenticated = true;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String token) async {
    await _storage.write(key: 'token', value: token);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<String?> checkToken() async {
    final token = await _storage.read(key: 'token');

    _isAuthenticated = token != null;
    notifyListeners();
    if (token != null) {
      print("Check token: token est disponible.");
      return token;
    }
    print("Check token: token n'est pas disponible.");
    return null;
  }
}

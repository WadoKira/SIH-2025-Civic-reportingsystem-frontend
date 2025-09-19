import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement actual authentication
      await Future.delayed(const Duration(seconds: 2));
      
      _user = UserModel(
        id: '1',
        name: 'John Doe',
        email: email,
        createdAt: DateTime.now(),
      );
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithEmail(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement actual registration
      await Future.delayed(const Duration(seconds: 2));
      
      _user = UserModel(
        id: '1',
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement Google Sign In
      await Future.delayed(const Duration(seconds: 2));
      
      _user = UserModel(
        id: '1',
        name: 'Google User',
        email: 'user@gmail.com',
        createdAt: DateTime.now(),
      );
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    // TODO: Check if user is already logged in
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }
}
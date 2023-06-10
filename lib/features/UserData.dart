import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _error = false;
  late User? _user;

  TextEditingController emailEditTextEditingController = TextEditingController();
  TextEditingController passwordEditTextEditingController = TextEditingController();

  UserDataModel() {
    _user = FirebaseAuth.instance.currentUser;
  }

  void changeEmail(String? value) {
    if (value != null) {
      _email = value;
    }
    notifyListeners();
  }
  void changePassword(String? value) {
    if (value != null) {
      _password = value;
    }
    notifyListeners();
  }

  void login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      _user = credential.user;
      _error = false;
    }

    on FirebaseAuthException catch (e) {
      _error = true;
      if (e.code == 'invalid-email') {
        print('Invalid Email');
      } else if (e.code == 'user-not-found') {
        print('User Not Found');
      } else if (e.code == 'wrong-password') {
        print('Wrong Password');
      } else {
        print('Login Error');
      }
    }
    notifyListeners();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  getUserData() {
    return _user;
  }

  String? getUserName() {
    return _user?.displayName;
  }

  bool getLoginError() {
    return _error;
  }

  @override
  void dispose() {
    emailEditTextEditingController.dispose();
    passwordEditTextEditingController.dispose();
    super.dispose();
  }
}
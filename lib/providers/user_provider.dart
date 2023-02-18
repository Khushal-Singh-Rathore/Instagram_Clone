import 'package:instagram/backend/auth_methods.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  // we are creating a getter for _user so that when calling user provider we won't get null value
  User get getUser => _user!;
}

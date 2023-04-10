import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/sign_up_method.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get getUser => _user!;
  Future<void> refreshUser() async {
    User? user = await Authentication().getUserDetails();
    _user = user;
    notifyListeners();
  }
}

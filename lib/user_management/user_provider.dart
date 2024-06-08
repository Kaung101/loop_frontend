import 'package:flutter/material.dart';
import 'package:loop/auth/auth_repo.dart';

class UserProvider with ChangeNotifier {
  final AuthRepository authRepository;
  Map<String, dynamic>? _userData;

  UserProvider(this.authRepository);

  Map<String, dynamic>? get userData => _userData;

  Future<void> fetchAndSetUserData() async {
    _userData = await authRepository.fetchUserData();
    notifyListeners();
  }


}

import 'package:flutter/cupertino.dart';

enum UserRole {Parent, Patient}

class RoleProvider extends ChangeNotifier{
  UserRole _currentUserRole = UserRole.Parent;

  UserRole get currentUserRole => _currentUserRole;

  void updateUserRole(UserRole newRole) {
    _currentUserRole = newRole;
    notifyListeners();
  }
}
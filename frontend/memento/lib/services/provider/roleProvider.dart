import 'package:flutter/cupertino.dart';

import '../../model/user.dart';

class RoleProvider extends ChangeNotifier{
  final List<String> _role = ['Parent', 'Patient'];
  List<String> get role => _role;

  // void addRole(String role){
  //   final index = _role.indexOf(role);
  //   return _role[index];
  //   notifyListeners();
  // }
  //
  // void deleteEvent(String role) {
  //   _users.remove(user);
  //   notifyListeners();
  // }
  //
  // void editEvent(String newRole, User oldUser) {
  //   final index = _users.indexOf(oldUser);
  //   _users[index] = newUser;
  //   notifyListeners();
  // }
}
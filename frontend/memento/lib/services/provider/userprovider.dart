import 'package:flutter/cupertino.dart';

import '../../model/user.dart';

class UserProvider extends ChangeNotifier{
  final List<User> _users = [];
  List<User> get users => _users;

  void addUser(User user){
    _users.add(user);
    notifyListeners();
  }

  void deleteEvent(User user) {
    _users.remove(user);
    notifyListeners();
  }

  void editEvent(User newUser, User oldUser) {
    final index = _users.indexOf(oldUser);
    _users[index] = newUser;
    notifyListeners();
  }
}
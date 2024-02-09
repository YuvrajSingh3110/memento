import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, this.role});
  final role;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String role = '';

  @override
  void initState() {
    role = widget.role;
    print("navbar $role");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

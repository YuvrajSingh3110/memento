import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:memento/views/parent/mapScreen.dart';
import 'package:memento/views/patient/chatBot.dart';
import 'package:memento/views/patient/mapscreenpatient.dart';
import 'package:memento/widgets/customDrawer.dart';

import '../views/parent/homeParent.dart';
import '../views/parent/profileParent.dart';
import '../views/patient/homePatient.dart';
import '../views/patient/profilePatient.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, this.role});
  final role;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String _role = "Parent";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> _parentList = [
    const HomeParent(),
    const MapScreenParent(),
    const ProfileParent(),
  ];

  final List<Widget> _patientList = [
    const HomePatient(),
    const ChatBot(),
    const ProfilePatient(),
  ];

  @override
  void initState() {
    _role = widget.role;
    print("navbar $_role");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // height
    double height = MediaQuery.of(context).size.height;
    // width
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      key: _scaffoldKey,
      // body: _pages[_selectedIndex],
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _role == "Parent" ? _parentList : _patientList,
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 15,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.01),
          decoration: const BoxDecoration(
            // color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: GNav(
                curve: Curves.easeOutExpo,
                // rippleColor: Colors.grey[300],
                // hoverColor: Colors.grey[100],
                haptic: true,
                tabBorderRadius: 20,
                gap: 5,
                activeColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor:
                Theme.of(context).primaryColor.withOpacity(0.8),
                // textStyle: Colors.white,
                tabs: [
                  GButton(
                    iconSize: _selectedIndex != 0 ? 28 : 25,
                    icon: _selectedIndex == 0
                        ? LineAwesomeIcons.home
                        : LineAwesomeIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    iconSize: 28,
                    icon: _role == "Parent" ?
                    (_selectedIndex == 1 ? Icons.map : Icons.map_outlined) : (_selectedIndex == 1 ? Icons.chat : Icons.chat_bubble),
                    text: _role == "Parent" ? 'Maps' : "Chat",
                  ),
                  // GButton(
                  //   iconSize: 29,
                  //   icon: _selectedIndex == 2
                  //       ? CupertinoIcons.settings_solid
                  //       : CupertinoIcons.settings_solid,
                  //   text: 'Help',
                  // ),
                  GButton(
                    iconSize: 29,
                    icon: _selectedIndex == 3
                        ? CupertinoIcons.person_solid
                        : CupertinoIcons.person,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memento/services/localDb/localDb.dart';
import 'package:memento/views/auth/phoneNumber.dart';
import 'package:memento/widgets/bottomNavBar.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class FirebaseApi {
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  String role = 'Parent';

  getLoggedinState() async {
    await LocalDb.getEmail().then((value) {
      print("value $value");
      setState(() {
        if (value.toString() != "null") {
          isLogin = true;
        }
      });
    });
  }

  getRoleState() async {
    await LocalDb.getRole().then((value) {
      print("role $value");
      setState(() {
        if (value.toString() == 'Patient') role = 'Patient';
      });
    });
  }

  @override
  void initState() {
    getLoggedinState();
    getRoleState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Memento',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: isLogin
            ? BottomNavBar(role: role)
            : const PhoneNumber(),
        // : isLogin && role == 'Patient'
        //     ? const QRGenerationScreen()
        //     : const Login(),
      );
  }
}

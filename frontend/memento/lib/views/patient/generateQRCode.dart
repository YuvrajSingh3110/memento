import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerationScreen extends StatefulWidget {
  const QRGenerationScreen({super.key});

  @override
  State<QRGenerationScreen> createState() => _QRGenerationScreenState();
}

class _QRGenerationScreenState extends State<QRGenerationScreen> {
  final qrKey = GlobalKey();
  String qrData = "Not Yet Scanned";
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  QrImageView(
          data: FirebaseAuth.instance.currentUser!.uid,
          version: QrVersions.auto,
          size: 200.0,
          backgroundColor: Colors.white,
          gapless: false,
        ),
      ),
    );
  }
}
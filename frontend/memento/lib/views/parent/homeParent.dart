import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:memento/services/linkUsers.dart';
import 'package:memento/widgets/patientCard.dart';

class HomeParent extends StatefulWidget {
  const HomeParent({super.key});

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  User? user = FirebaseAuth.instance.currentUser;
  String qrResult = "Not Yet Scanned";

   Future<void> scanQRCode() async {
    try {
      final String  id = user!.uid;
      print("id $id");
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", false, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        qrResult = qrCode;
        addUserIdTousersList(qrResult, id);
      });
    } on PlatformException {
      qrResult = "Failed to get platform version";
    }
  }

  List<String> ListPatientsUid = [];
  List<DocumentSnapshot> patientDetails = [];

  getPatientsDetails() async {
    await fetchPatients(user!.uid).then((patients) async {
      for(String patient in patients){
        await fetchPatientDetails(patient).then((patientDetail) => patientDetails.add(patientDetail));
      }
    });
    print(patientDetails);
    setState(() {});
  }

  @override
  void initState() {
    getPatientsDetails();
    print(patientDetails);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memento"),
        actions: [
          IconButton(
            onPressed: () {
              scanQRCode();
            },
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),
      body: ListView.builder(

          shrinkWrap: true,
          itemCount: patientDetails.length,
          itemBuilder: (context, index) {
            return PatientCard(
              patientName: patientDetails[index]["name"],
            );
          },
      )
    );
  }
}
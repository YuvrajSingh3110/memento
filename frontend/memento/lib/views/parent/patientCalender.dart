import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:memento/services/linkUsers.dart';
import 'package:memento/views/patient/eventEditing.dart';
import 'package:memento/widgets/eventCard.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/eventDataSource.dart';
import '../../services/provider/provider.dart';
import '../../widgets/taskWidget.dart';

class PatientCalender extends StatefulWidget {
  const PatientCalender({super.key});

  @override
  State<PatientCalender> createState() => _PatientCalenderState();
}

class _PatientCalenderState extends State<PatientCalender> {
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
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return Scaffold(
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.month,
          initialSelectedDate: DateTime.now(),
          cellBorderColor: Colors.transparent,
          dataSource: EventDataSource(events),
          onLongPress: (details){
            final provider = Provider.of<EventProvider>(context, listen: false);
            provider.setDate(details.date!);
            showModalBottomSheet(context: context, builder: (context) => TaskWidget());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EventEditingScreen()));
      }, child: const Icon(Icons.add),),
    );
  }
}

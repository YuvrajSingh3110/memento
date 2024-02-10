import 'package:flutter/material.dart';
import 'package:memento/views/parent/patientCalender.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.patientName});
  final String patientName;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: Text(
          patientName
        ),
        contentPadding: EdgeInsets.all(20),
        leading: const CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('assets/profile.png'),
        ),
        tileColor: Colors.grey,
        onTap: ()=>{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const PatientCalender()))
        },
      ),
    );
  }
}
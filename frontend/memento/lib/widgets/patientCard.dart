import 'package:flutter/material.dart';
import 'package:memento/views/parent/patientCalender.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.patientName});
  final String patientName;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: ListTile(
          title: Text(
            patientName, style: TextStyle(fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.all(20),
          leading: Container(
            child:
            ClipRRect(child: Image.asset("assets/profile.png"), borderRadius: BorderRadius.circular(8),)
          ),
          tileColor: Colors.transparent,
          trailing: Icon(Icons.arrow_forward),
          onTap: ()=>{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const PatientCalender()))
          },
        ),
      ),
    );
  }
}
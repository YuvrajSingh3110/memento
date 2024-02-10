import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  final String title;
  final String? desc;
  final DateTime from;
  final DateTime to;
  final GeoPoint position;
  final Color bgColor;
  final bool isAllDay;

  const Event(
      {required this.title,
      this.desc,
      required this.from,
      required this.to,
      required this.position,
      this.bgColor = Colors.lightBlueAccent,
      this.isAllDay = false});

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      title: map['title'],
      from: (map['from'] as Timestamp).toDate(),
      to: (map['to'] as Timestamp).toDate(),
      position: (map['location']),
      isAllDay: map['isAllDay'],
    );
  }
}

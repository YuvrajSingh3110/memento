import 'package:flutter/material.dart';

class Event {
  final String title;
  final String? desc;
  final DateTime from;
  final DateTime to;
  final Color bgColor;
  final bool isAllDay;

  const Event(
      {required this.title,
        this.desc,
        required this.from,
        required this.to,
        this.bgColor = Colors.lightBlueAccent,
        this.isAllDay = false});
}

import 'package:memento/views/patient/eventEditing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/event.dart';
import '../../services/provider/provider.dart';

class EventViewing extends StatefulWidget {
  final Event event;
  const EventViewing({super.key, required this.event});

  @override
  State<EventViewing> createState() => _EventViewingState();
}

class _EventViewingState extends State<EventViewing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildViewingActions(context, widget.event),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          buildDateTime(widget.event),
          const SizedBox(
            height: 30,
          ),
          Text(
            widget.event.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            widget.event.desc ?? "desc",
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? "All Day" : "From", event.from),
        if (!event.isAllDay) buildDate("To", event.to),
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(title),
              Text("$date"),
            ],
          )
        ],
      ),
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Event event) {
    return [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EventEditingScreen(event: event,))),
      ),
      IconButton(
        onPressed: () {
          final provider = Provider.of<EventProvider>(context, listen: false);
          provider.deleteEvent(event);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete),
      ),
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:memento/services/provider/provider.dart';
import 'package:provider/provider.dart';

class EventCard extends StatefulWidget {
  const EventCard({super.key, this.title, this.from, this.to});
  final title;
  final from;
  final to;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blueGrey
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(widget.title),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.from),
              Text(widget.to),
            ],
          )
        ],
      ),
    );
  }
}

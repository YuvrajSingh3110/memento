import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:memento/views/patient/mapscreenpatient.dart';
import 'package:provider/provider.dart';

import '../../model/event.dart';
import '../../services/provider/provider.dart';

class ShowEvents extends StatefulWidget {
  const ShowEvents({super.key});

  @override
  State<ShowEvents> createState() => _ShowEventsState();
}

class _ShowEventsState extends State<ShowEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          return FutureBuilder(
            future: eventProvider.fetchEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || (snapshot.data as List<Event>).isEmpty) {
                return const Text('No events available');
              } else {
                return ListView.builder(
                  itemCount: (snapshot.data as List<Event>).length,
                  itemBuilder: (context, index) {
                    Event event = (snapshot.data as List<Event>)[index];

                    // Format the date and time using DateFormat
                    String formattedDateTime = '${DateFormat.d().format(event.from)}'
                        '${DateFormat.yMMM().format(event.from)} '
                        '${DateFormat.jm().format(event.from)} - '
                        '${DateFormat.jm().format(event.to)}';

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                event.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                formattedDateTime,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          trailing: Icon(Icons.arrow_forward), // Add your arrow icon
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreenPatient(position: LatLng(event.position.latitude, event.position.longitude))));
                          },
                        ),
                      ),
                    );

                  },
                );

              }
            },
          );
        },
      ),
    );
  }
}

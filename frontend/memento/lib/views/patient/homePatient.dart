import 'package:memento/views/patient/eventEditing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/eventDataSource.dart';
import '../../services/provider/provider.dart';
import '../../widgets/taskWidget.dart';

class HomePatient extends StatefulWidget {
  const HomePatient({super.key});

  @override
  State<HomePatient> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePatient> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return Scaffold(
      body: Container(
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
      }, child: Icon(Icons.add),),
    );
  }
}
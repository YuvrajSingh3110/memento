import 'package:flutter/material.dart';
import 'package:memento/views/patient/eventEditing.dart';
import 'package:memento/widgets/eventCard.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/eventDataSource.dart';
import '../../services/provider/provider.dart';
import '../../widgets/taskWidget.dart';

class HomeParent extends StatefulWidget {
  const HomeParent({super.key});

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
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

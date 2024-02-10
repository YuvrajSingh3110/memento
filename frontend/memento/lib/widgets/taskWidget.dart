import 'package:memento/model/eventDataSource.dart';
import 'package:flutter/material.dart';
import 'package:memento/views/patient/showEvents.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../services/provider/provider.dart';
import '../views/patient/eventViewing.dart';


class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    if(selectedEvents.isEmpty){
      return Center(
        child: Text("No Events found", style: TextStyle(color: Colors.black, fontSize: 20),),
      );
    }
    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: const TextStyle(fontSize: 15, color: Colors.black)
      ),
      child: SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(provider.events),
        initialDisplayDate: provider.selectedDate,
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
        ),
        onTap: (details) {
          if(details.appointments == null) return;
          final event = details.appointments!.first;
          //Navigator.push(context, MaterialPageRoute(builder: (context) => EventViewing(event: event),));
          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowEvents(),));
        },
      )
    );
  }

  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details,
      ){
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.bgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Center(
        child: Text(
          event.title,
          maxLines: 2,
            overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

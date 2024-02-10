import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memento/model/event.dart';
import 'package:memento/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/provider/provider.dart';

class EventEditingScreen extends StatefulWidget {
  const EventEditingScreen({super.key, this.event});

  final Event? event;

  @override
  State<EventEditingScreen> createState() => _EventEditingScreenState();
}

class _EventEditingScreenState extends State<EventEditingScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now();
    }else{
      final event = widget.event;
      _titleController.text = event!.title;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                child: buildDateTimePicker(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        icon: Icon(Icons.done),
        label: Text("Save"),
        onPressed: saveForm)
  ];

  Widget buildTitle() => TextFormField(
    style: TextStyle(fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: "Add title",
    ),
    onFieldSubmitted: (_) => saveForm(),
    controller: _titleController,
    validator: (title) =>
    title != null && title.isEmpty ? 'Title cannot be empty' : null,
  );

  Widget buildDateTimePicker() => Column(
    children: [buildFrom(), buildTo()],
  );

  Widget buildFrom() => buildHeader(
    header: 'FROM',
    child: Row(
      children: [
        Expanded(
            flex: 2,
            child: buildDropDownField(
              text: Utils.toDate(fromDate),
              onClicked: () => pickFromDateTime(pickDate: true),
            )),
        Expanded(
            child: buildDropDownField(
                text: Utils.toTime(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false))),
      ],
    ),
  );

  Widget buildTo() => buildHeader(
    header: 'TO',
    child: Row(
      children: [
        Expanded(
            flex: 2,
            child: buildDropDownField(
                text: Utils.toDate(toDate),
                onClicked: () => pickToDateTime(pickDate: true))),
        Expanded(
            child: buildDropDownField(
                text: Utils.toTime(toDate),
                onClicked: () => pickToDateTime(pickDate: false))),
      ],
    ),
  );

  Future pickFromDateTime({
    required bool pickDate,
  }) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() => fromDate = date);
  }

  Future pickToDateTime({
    required bool pickDate,
  }) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;
    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
      DateTime initialDate, {
        required bool pickDate,
        DateTime? firstDate,
      }) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (date == null) return null;
      final time =
      Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;
      final date =
      DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget buildDropDownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        onTap: onClicked,
      );

  Widget buildHeader({required String header, required Widget child}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        header,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      child
    ],
  );

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final event = Event(
          title: _titleController.text,
          from: fromDate,
          to: toDate,
          isAllDay: false, position: GeoPoint(31.3254611,75.5173362));

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);
      if(isEditing){
        provider.editEvent(event, widget.event!);
        Navigator.pop(context);
      }else{
        provider.addEvent(event);
      }
      Navigator.pop(context);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:memento/model/event.dart';
import 'package:memento/services/localDb/localDb.dart';
import 'package:memento/services/provider/roleProvider.dart';
import 'package:provider/provider.dart';

class EventProvider extends ChangeNotifier {
  final user = FirebaseAuth.instance;
  final List<Event> _events = [];
  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => _events;

  // void getRole(BuildContext context){
  //   RoleProvider roleProvider = Provider.of<RoleProvider>(context, listen: false);
  //   UserRole userRole = RoleProvider.currentUserRole;
  // }

  void addEvent(Event event) async{
    await addEventToFirestore(event);
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(Event event) async{
    final index = _events.indexOf(event).toString();
    await deleteEventFromFirestore(index);
    _events.remove(event);
    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) async{
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    await updateEventToFirestore(index, newEvent);
    notifyListeners();
  }

  Future<void> addEventToFirestore(Event event) async {
    String? role = await LocalDb.getRole();
    role = role?.toLowerCase();
    final CollectionReference<Map<String, dynamic>> eventsCollection = FirebaseFirestore.instance
        .collection(role!);

    Map<String, dynamic> eventMap = {
      'title': event.title,
      'from': event.from,
      'to': event.to,
      'isAllDay': event.isAllDay,
    };

    await eventsCollection.doc(user.currentUser!.uid).collection('event').add(eventMap);
    print("added event in firebase with");
    print(eventMap);
  }

  Future<void> deleteEventFromFirestore(String eventId) async {
    String? role = await LocalDb.getRole();
    role = role?.toLowerCase();
    final CollectionReference eventsCollection = FirebaseFirestore.instance
    .collection(role!)
        .doc(user.currentUser!.uid)
        .collection('events');
    await eventsCollection.doc(eventId).delete();
  }

  Future<void> updateEventToFirestore(int index, Event event) async {
    String? role = await LocalDb.getRole();
    role = role?.toLowerCase();
    String eventId = index.toString();
    final CollectionReference<Map<String, dynamic>> eventsCollection = FirebaseFirestore.instance
    .collection(role!);

    Map<String, dynamic> eventMap = {
      'title': event.title,
      'from': event.from,
      'to': event.to,
      'isAllDay': event.isAllDay,
    };

    await eventsCollection.doc(user.currentUser!.uid).collection("event").doc(eventId).update(eventMap);
    print("updated event in firebase");
  }
}

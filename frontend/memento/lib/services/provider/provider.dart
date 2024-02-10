import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:memento/model/event.dart';
import 'package:memento/services/localDb/localDb.dart';

class EventProvider extends ChangeNotifier {
  final user = FirebaseAuth.instance;
  List<Event> _events = [];
  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => _events;

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
    final CollectionReference<Map<String, dynamic>> eventsCollection = FirebaseFirestore.instance
        .collection('patient');

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
    final CollectionReference eventsCollection = FirebaseFirestore.instance
    .collection("patient")
        .doc(user.currentUser!.uid)
        .collection('events');
    await eventsCollection.doc(eventId).delete();
  }

  Future<void> updateEventToFirestore(int index, Event event) async {
    String eventId = index.toString();
    final CollectionReference<Map<String, dynamic>> eventsCollection = FirebaseFirestore.instance
    .collection("patient");

    Map<String, dynamic> eventMap = {
      'title': event.title,
      'from': event.from,
      'to': event.to,
      'isAllDay': event.isAllDay,
    };

    await eventsCollection.doc(user.currentUser!.uid).collection("event").doc(eventId).update(eventMap);
    print("updated event in firebase");
  }

  Future<List<Event>?> fetchEvents() async {
    try {
      final QuerySnapshot eventSnapshot = await FirebaseFirestore.instance.collection("patient").doc(user.currentUser!.uid).collection("event").get();
      List<String> eventIDs = eventSnapshot.docs.map((doc) => doc).cast<String>().toList();
      final List<Event> fetchedEvents = await _fetchEventsDetails(eventIDs);
      print("fetchedEvents $fetchedEvents");
      //_events = fetchedEvents;
      return fetchedEvents;
      //_events = eventSnapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error fetching events: $error');
      return null;
    }
  }

  Future<List<Event>> _fetchEventsDetails(List<String> eventIDs) async {
    String? role = await LocalDb.getRole();
    role = role?.toLowerCase();
    // Fetch event details from the 'events' collection based on event IDs
    final List<Future<Event>> futures = eventIDs.map((eventID) async {
      final DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance.collection(role!).doc(user.currentUser!.uid).collection("event").doc(eventID).get();
      return Event.fromMap(eventSnapshot.data() as Map<String, dynamic>, eventSnapshot.id);
    }).toList();

    return Future.wait(futures);
  }
}

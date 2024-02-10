import 'package:cloud_firestore/cloud_firestore.dart';

void addUserIdTousersList(String patientUserId, String currentUserId) async {

  // Access the users collection
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  print("Adding $patientUserId to $currentUserId's patients list");

  await usersCollection.doc(currentUserId).update({
    'patients': FieldValue.arrayUnion([patientUserId])
  });
  print("updated");
}

// fetch all the patients of a parent
Future<List<String>> fetchPatients(String currentUserId) async {
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot user = await usersCollection.doc(currentUserId).get();
  List<String> patients = List.from(user.get('patients'));
  return patients;
}

//fetch patients LatLng from the database
Future<GeoPoint> fetchPatientLatLng(String patientUserId) async {
  CollectionReference patientCollection = FirebaseFirestore.instance.collection('patient');
  DocumentSnapshot patient = await patientCollection.doc(patientUserId).get();
  GeoPoint patientData = patient.get('location');
  return patientData;
}

// polling for fetchPatientLatLng
Future<GeoPoint> pollingForFetchPatientLatLng(String patientUserId) async {
  while (true) {
    try {
      GeoPoint patientLatLng = await fetchPatientLatLng(patientUserId);
      return patientLatLng;
    } catch (e) {
      print("Error fetching patient's LatLng: $e");
      // Retry after 1 second
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

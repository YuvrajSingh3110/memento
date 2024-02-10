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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<QuerySnapshot<Map<String, dynamic>>?> GetUsersData() async{
  try{
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      QuerySnapshot<Map<String, dynamic>> patientData = (await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('patients').get());
      return patientData;
    }else{
      throw FirebaseAuthException(
        code: 'user-not-logged-in',
        message: 'No user is currently logged in.',
      );
    }
  }catch(e){
    print('Error fetching user data: $e');
    throw e;
  }
  return null;
}
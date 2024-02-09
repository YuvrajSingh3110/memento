import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:memento/services/localDb/localDb.dart';
import 'package:memento/views/auth/userDetails.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key, this.mobile});
  final mobile;

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _auth = FirebaseAuth.instance;
  String mobile = "";

  @override
  void initState() {
    mobile = widget.mobile;
    signup(mobile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("An otp is sent to your phone number $mobile"),
          const SizedBox(
            height: 20,
          ),
          OtpTextField(
            numberOfFields: 5,
            borderColor: Color(0xFF512DA8),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode){
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Text("Verification Code"),
                      content: Text('Code entered is $verificationCode'),
                    );
                  }
              );
            }, // end onSubmit
          ),
        ],
      ),
    );
  }

  void signup(String mobile) async {
    const CircularProgressIndicator();
    await _auth
        .verifyPhoneNumber(
      phoneNumber: '+91 $mobile',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .then((value) =>
            {postDetailsToFirestore(mobile)})
        .catchError((e) {});
  }

  postDetailsToFirestore(String mobile) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = firebaseFirestore.collection('users');
    ref.doc(user!.uid).set({
      'phone number': mobile
    });
    await LocalDb.saveMobile(mobile);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserDetails()));
  }
}

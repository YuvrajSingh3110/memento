import 'package:flutter/material.dart';
import 'package:memento/views/auth/otp.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  TextEditingController mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: mobileNumberController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Phone Number',
              enabled: true,
              contentPadding: const EdgeInsets.only(
                  left: 14.0, bottom: 8.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Phone Number cannot be empty";
              }
              if (!RegExp(
                  r'^(?:[+0]9)?[0-9]{10}$')
                  .hasMatch(value)) {
                return ("Please enter a valid mobile number");
              } else {
                return null;
              }
            },
            onChanged: (value) {},
            keyboardType: TextInputType.number,
          ),
          MaterialButton(
            shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(20.0))),
            elevation: 5.0,
            height: 40,
            onPressed: () {
              String mobile = mobileNumberController.text;
              print(mobile);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpVerification(mobile: mobile)));
            },
            color: Colors.white,
            child: const Text(
              "Submit",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

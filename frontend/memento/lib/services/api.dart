import 'dart:convert';

import 'package:http/http.dart' as http;

class API {
  // create this class singelton
  static final API _instance = API._internal();
  factory API() => _instance;
  API._internal();

  String BASE_URL = "http://localhost:3000/vonage";

  Future<void> sendSMS(String phoneNumber, String message) async {
    var url = Uri.parse("$BASE_URL/sms");
    phoneNumber = phoneNumber.replaceAll("+", "");
    await http.post(url, body: {
      "message": message,
    });
    return;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms_android/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  final String msgContent = 'Emergency! Please help!';
  List<String> recipents = ["+917986459449"];

  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '$phoneNumber?body=$msgContent',
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendTextMsgs(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: '$phoneNumber?body=$msgContent',
    );
    await launchUrl(launchUri);
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    final String _phoneNumber = '+917986459449';

    return Drawer(
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.call),
              onPressed: _hasCallSupport
                  ? () => setState(() {
                //_launched = _sendTextMsgs(_phoneNumber);
                _callNumber(_phoneNumber);
              })
                  : null,
            ),
            IconButton(onPressed: () {
              _sendSMS("hehe", recipents);
            },
              icon: Icon(Icons.message)
            )],
        ),
      ),
    );
  }
}

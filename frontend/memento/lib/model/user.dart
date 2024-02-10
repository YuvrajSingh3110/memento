import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  final String name;
  final String email;
  final String age;
  final String role;
  final LatLng latitude;
  final LatLng longitude;
  final List<User>? patients;

  const User(
      {required this.name,
      required this.email,
      required this.age,
      required this.role,
      required this.latitude,
      required this.longitude,
        this.patients});
}

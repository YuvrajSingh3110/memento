import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:memento/model/event.dart';
import 'package:memento/services/linkUsers.dart';
import 'package:provider/provider.dart';

import '../../services/provider/provider.dart';

class MapScreenPatient extends StatefulWidget {
  const MapScreenPatient({super.key,required this.position});
  final position;

  @override
  State<MapScreenPatient> createState() => _MapScreenPatientState();
}

class _MapScreenPatientState extends State<MapScreenPatient> {
  final mapsApiKey = "AIzaSyBAC_OF_lWBfFr_Zjs-mO0Kwyr4f_faiMU";
  late GoogleMapController mapController;
  String? user_id = FirebaseAuth.instance.currentUser!.uid;
  // LocationData? _currentLocation = LocationData.fromMap({
  //   "latitude": 31.3310016,
  //   "longitude" : 75.5734925,
  // });

  // BitmapDescriptor sourceIcon = BitmapDescriptor as BitmapDescriptor;
  // BitmapDescriptor destIcon = BitmapDescriptor.defaultMarker;
  // BitmapDescriptor currLocIcon = BitmapDescriptor.defaultMarker;

  List<LatLng> polyLineCoordinates = [];
  List<LatLng> patientLatLng = [];

  //final LatLng _center = const LatLng(45.521563, -122.677433);
  // final LatLng sourceLocation = const LatLng(31.3254611, 75.5173362);
  LatLng destLocation = const LatLng(31.3310016, 75.5734925);
  LatLng currentLocation = const LatLng(23.207326, 72.582606);

  // void _getCurrentLocation() async {
  //   Location location = Location();
  //   location.getLocation().then((value) {
  //     _currentLocation = value;
  //     print(_currentLocation);
  //   });
  //   location.onLocationChanged.listen((newLoc) {
  //     _currentLocation = newLoc;
  //     mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //         zoom: 14, target: LatLng(newLoc.latitude!, newLoc.longitude!))));
  //     setState(() {});
  //   });
  // }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  void getPolyPoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
      mapsApiKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destLocation.latitude, destLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

  // Future<void> getEventRoutes(LatLng position) async{
  //   final provider = Provider.of<EventProvider>(context, listen: false);
  //   List<Event>? userEvent = await provider.fetchEvents();
  //   print("UserEvent $userEvent");
  //   if (userEvent != null && userEvent.isNotEmpty) {
  //     //userEvent.sort((a, b) => a.from.compareTo(b.from));
  //     List<GeoPoint> locations = userEvent.map((event) => event.position).toList();
  //     print("Sorted Events: $userEvent");
  //     print("Locations: $locations");
  //     setState(() {
  //       destLocation = locations[index].latitude as LatLng;
  //     });
  //   } else {
  //     print("No events found");
  //   }
  // }

  @override
  void initState() {
    destLocation = widget.position;
    //getEventRoutes(position)
    super.initState();
  }

  // void setCustomMarker(){
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "").then((icon) {
  //     sourceIcon = icon;
  //   });
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "").then((icon) {
  //     destIcon = icon;
  //   });
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "").then((icon) {
  //     currLocIcon = icon;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.204930, 72.584301),
          zoom: 14,
        ),
        polylines: {
          Polyline(
              polylineId: const PolylineId("route"),
              points: polyLineCoordinates,
              color: Colors.blue,
              width: 6)
        },
        markers: {
          for (var latLng in patientLatLng)
            Marker(
              markerId: MarkerId(latLng.toString()),
              position: latLng,
            ),
          Marker(
            markerId: MarkerId("destination"),
            position: destLocation
          )
        },
        myLocationEnabled: true,
      ),
    );
  }
}
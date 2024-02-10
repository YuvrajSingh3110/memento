import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapsApiKey = "AIzaSyBAC_OF_lWBfFr_Zjs-mO0Kwyr4f_faiMU";
  late GoogleMapController mapController;
  LocationData? _currentLocation = LocationData.fromMap({
    "latitude": 31.3310016,
    "longitude" : 75.5734925,
  });

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currLocIcon = BitmapDescriptor.defaultMarker;

  List<LatLng> polyLineCoordinates = [];

  //final LatLng _center = const LatLng(45.521563, -122.677433);
  final LatLng sourceLocation = const LatLng(31.3254611, 75.5173362);
  final LatLng destLocation = const LatLng(31.3310016, 75.5734925);

  void _getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((value) {
      _currentLocation = value;
      print(_currentLocation);
    });
    location.onLocationChanged.listen((newLoc) {
      _currentLocation = newLoc;
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          zoom: 14, target: LatLng(newLoc.latitude!, newLoc.longitude!))));
      setState(() {});
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Future<void> _getCurrentLocation() async {
  //   var location = Location();
  //   try {
  //     LocationData currentLocation = await location.getLocation();
  //     setState(() {
  //       _currentLocation = currentLocation;
  //       print(_currentLocation);
  //     });
  //   } catch (e) {
  //     print('Error getting location: $e');
  //   }
  // }

  void getPolyPoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
      mapsApiKey,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destLocation.latitude, destLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

  @override
  void initState() {
    _getCurrentLocation();
    getPolyPoints();
    //setCustomMarker();
    super.initState();
  }

  void setCustomMarker(){
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "").then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "").then((icon) {
      destIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "").then((icon) {
      currLocIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _currentLocation != null
            ? CameraPosition(
                target: LatLng(
                    _currentLocation!.latitude!, _currentLocation!.longitude!),
                zoom: 14.0,
              )
            : CameraPosition(
                target: sourceLocation,
                zoom: 14.0,
              ),
        polylines: {
          Polyline(
              polylineId: const PolylineId("route"),
              points: polyLineCoordinates,
              color: Colors.blue,
              width: 6)
        },
        markers: {
          Marker(
            markerId: const MarkerId("current location"),
            position: LatLng(
                _currentLocation!.latitude!, _currentLocation!.longitude!),
          ),
          Marker(
            markerId: const MarkerId("source"),
            position: sourceLocation,
          ),
          Marker(
            markerId: const MarkerId("destination"),
            position: destLocation,
          ),
        },
        myLocationEnabled: true,
      ),
    );
  }
}
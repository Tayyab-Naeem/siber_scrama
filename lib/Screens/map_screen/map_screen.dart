import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  Position? _currentPosition;
  Marker? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _currentLocation = Marker(
          markerId: const MarkerId("current_location"),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
      });

      // Store the current location in Firestore
      _storeLocationInFirestore(_currentPosition!);
    } else {
      await Permission.location.request();
    }
  }

  void _storeLocationInFirestore(Position position) async {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(userUid).set({
      'location': GeoPoint(position.latitude, position.longitude),
    }, SetOptions(merge: true));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Location Map'),
        elevation: 0.0,
        backgroundColor: const Color(0xFFFF8822),
      ),
      body: Center(
        child: _currentPosition == null
            ? const CircularProgressIndicator()
            : GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  zoom: 15,
                ),
                markers:
                    _currentLocation != null ? {_currentLocation!} : <Marker>{},
              ),
      ),
    );
  }
}

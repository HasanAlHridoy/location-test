import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GPSTrackingAttendance extends StatefulWidget {
  const GPSTrackingAttendance({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GPSTrackingAttendanceState createState() => _GPSTrackingAttendanceState();
}

class _GPSTrackingAttendanceState extends State<GPSTrackingAttendance> {
  // Set your predefined location (Office/School GPS Coordinates)
  final double targetLatitude = 23.863794465127274; // Example: Dhaka, Bangladesh 23.863794465127274, 90.39897328465992
  final double targetLongitude = 90.39897328465992;
  final double allowedDistanceInMeters = 50; // 50-meter radius

  bool _isWithinAllowedDistance = false;
  String _currentLocation = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLocation();
  }

  // Function to request location permissions and fetch user's location
  Future<void> _checkPermissionAndLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if GPS is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "GPS is disabled. Please enable it.");
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permissions are permanently denied. Enable them from settings.");
      return;
    }

    // Get current location
    _getUserLocation();
  }

  // Function to fetch user's current location
  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentLocation = "Lat: ${position.latitude}, Lon: ${position.longitude}";
      });

      // Check if user is within the allowed radius
      _checkDistance(position.latitude, position.longitude);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error getting location: $e");
    }
  }

  // Function to calculate distance between user & predefined location
  void _checkDistance(double userLat, double userLng) {
    double distance = Geolocator.distanceBetween(userLat, userLng, targetLatitude, targetLongitude);

    setState(() {
      _isWithinAllowedDistance = distance <= allowedDistanceInMeters;
    });

    // Show distance to the user
    Fluttertoast.showToast(msg: "Distance from office: ${distance.toStringAsFixed(2)} meters");

    if (_isWithinAllowedDistance) {
      Fluttertoast.showToast(msg: "You are within the allowed area.");
    } else {
      Fluttertoast.showToast(msg: "You are outside the allowed 50-meter radius.");
    }
  }

  // Function to handle attendance submission
  void _submitAttendance() {
    if (_isWithinAllowedDistance) {
      Fluttertoast.showToast(msg: "Attendance marked successfully!");
      // Here, you can send data to your backend or database
    } else {
      Fluttertoast.showToast(msg: "You are too far from the designated location.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS Attendance System")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Location:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(_currentLocation, style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
            SizedBox(height: 20),
            _isWithinAllowedDistance
                ? Text("✅ You are inside the allowed area", style: TextStyle(color: Colors.green, fontSize: 16))
                : Text("❌ You are outside the allowed area", style: TextStyle(color: Colors.red, fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAttendance,
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
              child: Text("Submit Attendance"),
            ),
          ],
        ),
      ),
    );
  }
}

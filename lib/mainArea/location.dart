import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;
  bool _isUpdatingLocation = false;

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> getLocationPermission() async {
    final Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // Location service is disabled, handle accordingly
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // Location permission not granted, handle accordingly
      }
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    final Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('Error getting location: $e');
      return null; // Handle location retrieval error
    }
  }

  void startUpdatingLocation() async {
    await getLocationPermission();

    _locationSubscription?.cancel();
    _locationSubscription = Location().onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
    });

    setState(() {
      _isUpdatingLocation = true;
    });
  }

  void stopUpdatingLocation() {
    _locationSubscription?.cancel();
    setState(() {
      _isUpdatingLocation = false;
    });
  }

  void openGoogleMaps() async {
    if (_currentLocation != null) {
      final String url =
          'https://www.google.com/maps/search/?api=1&query=${_currentLocation!.latitude},${_currentLocation!.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isUpdatingLocation ? stopUpdatingLocation : startUpdatingLocation,
              child: Text(_isUpdatingLocation ? 'Stop Updating' : 'Start Updating'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: openGoogleMaps,
              child: Text('Open Google Maps'),
            ),
            SizedBox(height: 20),
            if (_currentLocation != null)
              Column(
                children: [
                  Text(
                    'Latitude: ${_currentLocation!.latitude}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Longitude: ${_currentLocation!.longitude}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

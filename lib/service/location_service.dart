import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocationService {
  Future<String?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Location services are disabled.");
      return null;
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permission denied.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permission permanently denied.");
      return null;
    }

    // Get the current position using locationSettings instead of settings
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,  // Can be customized for specific platform settings
        distanceFilter: 100,  // Specify the distance interval to receive updates (e.g., every 100 meters)
      ),
    );

    // For now, we return a hardcoded country code ('us')
    return 'us';
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  Future<String?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Location services are disabled.");
      return 'us';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permission denied.");
        return 'us';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permission permanently denied.");
      return 'us';
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final geoUrl =
          'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.latitude}&longitude=${position.longitude}&localityLanguage=en';

      final response = await http.get(Uri.parse(geoUrl)).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Location request timed out.");
          return http.Response('{"countryCode": "us"}', 408);
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('countryCode')) {
          return data['countryCode'];
        } else {
          Fluttertoast.showToast(msg: "Country code not found in response.");
          return 'us';
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch country code.");
        return 'us';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching country code: $e");
      return 'us';
    }
  }
}
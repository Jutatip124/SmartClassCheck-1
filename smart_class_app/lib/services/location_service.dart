import 'package:geolocator/geolocator.dart';

class LocationService {

  Future<Position?> getCurrentLocation() async {
    try {

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

    } catch (e) {
      print("Location error: $e");
      return null;
    }
  }

  String formatCoordinates(double lat, double lng) {
    return '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
  }
}
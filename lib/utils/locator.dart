import 'package:geolocator/geolocator.dart';

int _retry = 0;
bool _hasError = false;
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  try {
    _hasError = false;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    await Geolocator.getCurrentPosition().then((value) => print(value));
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    _hasError = true;
    print(e);
    if (_retry < 3) {
      _retry++;
      print('Error occured, retrying $_retry time(s) ');
      return determinePosition();
    } else {
      return Future.error('Location services are disabled.');
    }
  } finally {
    if (!_hasError) _retry = 0;
  }
}

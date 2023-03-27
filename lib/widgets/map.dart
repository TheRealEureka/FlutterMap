
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/locator.dart';

List<Marker> markers = [];

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Future<LatLng> getPos() async {
    try {
      Position pos = await determinePosition();
      return LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      print(e);
      return LatLng(45.5231, -122.6765);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return FutureBuilder(
      future: getPos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          LatLng pos = LatLng(48.692055, 6.184417);
          if (!snapshot.hasError && snapshot.data != null) {
            pos = snapshot.data as LatLng;
          }
          return Center(
            child: SizedBox(
              width: queryData.size.width,
              height: queryData.size.height,
              child: FlutterMap(
                options: MapOptions(
                  center: pos,
                  zoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: markers),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: pos,
                        builder: (ctx) => const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddMarker extends StatefulWidget {
  @override
  _AddMarkerState createState() => _AddMarkerState();
}

class _AddMarkerState extends State<AddMarker> {
  LatLng initialPosition = LatLng(8.5380, 124.7889);
  List<Marker> myMarker = [];
  LatLng placeMarker;
  String val;
  pinMarker(newMarker) {
    setState(() {
      placeMarker = newMarker;
      myMarker = [];
      myMarker.add(
        Marker(markerId: MarkerId(placeMarker.toString()), position: newMarker),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
              child: Row(
                children: [
                  Text(
                    'Select',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Icon(
                    Icons.check_box_outlined,
                    color: Colors.white,
                  )
                ],
              ),
              onPressed: () {
                Navigator.pop(context, placeMarker);
                print(
                    "===============================MARKER========================");
                print(placeMarker);
              }),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 18.5,
          ),
          mapType: MapType.normal,
          myLocationEnabled: true,
          markers: Set.from(myMarker),
          onTap: pinMarker,
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PlacePickerPage extends StatefulWidget {
  final LatLng latLng;

  PlacePickerPage({this.latLng});

  @override
  _PlacePickerPageState createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng latLng;

  final appbar = NeumorphicAppBar(
    centerTitle: true,
    title: Text('Заявка'),
  );

  @override
  void initState() {
    if (widget.latLng != null && widget.latLng is LatLng) {
      latLng = widget.latLng;
    } else {
      new Location()
          .getLocation()
          .then((value) => latLng = LatLng(value.latitude, value.longitude));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Выберите место', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),

      body: GoogleMap(
        mapType: MapType.normal,
        padding: const EdgeInsets.all(32),
        myLocationButtonEnabled: true,
        onTap: (latLng) => Navigator.of(context).pop(latLng),
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: latLng ?? LatLng(42.8767897, 74.4517753),zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

}

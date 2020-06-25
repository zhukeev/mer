import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePickerPage extends StatefulWidget {
  @override
  _PlacePickerPageState createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Text('Заявка'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),

        ],
      ),
    );
  }

  void showSnackbar(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text('Вы удалили уведомление'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue,
          action: SnackBarAction(
              label: 'отмена'.toUpperCase(),
              textColor: Colors.white,
              onPressed: () {}),
        ))
        .closed
        .then((reason) {
      if (reason != SnackBarClosedReason.action) {}
    });
  }
}

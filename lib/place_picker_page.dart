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
      backgroundColor: NeumorphicTheme.baseColor(context),
      /* appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Text('Заявка'),
      ),*/
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - kToolbarHeight,
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  padding: const EdgeInsets.all(32),
                  myLocationButtonEnabled: true,
                  onTap: (latLng) => Navigator.of(context).pop(latLng),
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: latLng ?? LatLng(42.8767897, 74.4517753)),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
            SizedBox(
              height: appbar.preferredSize.height * 1.2,
              child: NeumorphicAppBar(
                centerTitle: true,
                color: Colors.transparent,
                title: Text(
                  'Выберите место',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:mer/place_picker_page.dart';

class NewRequestPage extends StatefulWidget {
  @override
  _NewRequestPageState createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {
  final descriptionTEC = TextEditingController();
  final addressTEC = TextEditingController();

  LocationData _locationData;

  Map<int, File> _images = Map<int, File>();

  static const URL =
      "https://eu1.locationiq.com/v1/reverse.php?key=3309b7b528ff21&format=json&";

  @override
  void initState() {
    _location();

    super.initState();
  }

  Future<void> _location() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Text('Заявка'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Neumorphic(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: <Widget>[
                    TextFormField(
                      controller: addressTEC,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(60),
                      ],
                      validator: (val) =>
                          val.isEmpty ? 'Обязательное поле' : null,
                      decoration: InputDecoration(
                          labelText: 'Адрес',
                          contentPadding: const EdgeInsets.only(right: 40)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            final place = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => PlacePickerPage(
                                          latLng: LatLng(
                                              _locationData?.latitude,
                                              _locationData?.longitude),
                                        )));
                            if (place != null && place is LatLng) {
                              /*
                              * {
    "place_id": "127439665",
    "licence": "https://locationiq.com/attribution",
    "osm_type": "way",
    "osm_id": "177297807",
    "lat": "42.8941236",
    "lon": "74.58152355",
    "display_name": "109, Осипенко улица, Газ городок, Бишкек, 720004, Киргизия",
    "address": {
        "house_number": "109",
        "road": "Осипенко улица",
        "suburb": "Газ городок",
        "city": "Бишкек",
        "postcode": "720004",
        "country": "Киргизия",
        "country_code": "kg"
    },
    "boundingbox": ["42.8940766", "42.8941706", "74.581463", "74.5815841"]
}
                              * */

                              final response = await http.get(
                                  URL +
                                      "lat=${place.latitude}&lon=${place.longitude}",
                                  headers: {"accept-language": "ru"});

                              final Map<String, dynamic> data =
                                  jsonDecode(response.body);

                              addressTEC.text = data['display_name'];
                            }
                          },
                          icon: Icon(Icons.location_on)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Neumorphic(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: descriptionTEC,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 200,
                  validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                  decoration: InputDecoration(labelText: 'Описание'),
                ),
              ),
              SizedBox(height: 8),
              Neumorphic(
                child: GridView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final isOdd = index % 2 == 0;
                    return GestureDetector(
                      onTap: () async {
                        final f = await getImage();
                        if (f != null) {
                          _images[index] = f;
                          setState(() {});
                        }
                      },
                      child: Neumorphic(
                        margin: EdgeInsets.only(
                            left: isOdd ? 0 : 4,
                            right: isOdd ? 4 : 0,
                            bottom: 8),
                        padding: EdgeInsets.only(
                            left: isOdd ? 0 : 4,
                            right: isOdd ? 4 : 0,
                            bottom: 8),
                        child: Container(
//                      color: Color(0xFF363636),
                          child: _images.containsKey(index)
                              ? Image.file(
                                  _images[index],
                                  fit: BoxFit.cover,
                                )
                              : Center(child: Icon(Icons.photo)),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.maxFinite,
                height: 56,
                child: NeumorphicButton(
                  child: Center(
                    child: Text('Отправить', textAlign: TextAlign.center),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
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

  Future<File> getImage() async {
    final picker = ImagePicker();

    File _file;

    ImageSource imageSource = ImageSource.camera;

    final source = await showDialog(
        context: context,
        builder: (_) => Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                Navigator.of(context).pop(ImageSource.camera);
                              }),
                          Text('Камера')
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.photo),
                              onPressed: () {
                                Navigator.of(context).pop(ImageSource.gallery);
                              }),
                          Text('Галерея'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ));

    if (source is ImageSource) {
      final f = await picker.getImage(source: source);

      if (f != null && File(f.path).existsSync()) _file = File(f.path);
    }

    return _file;
  }
}

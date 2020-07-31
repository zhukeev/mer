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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text('Новая Заявка', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: descriptionTEC,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 3,
                  maxLength: 200,
                  validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                  decoration: InputDecoration(labelText: 'Описание'),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

                            await _location();

                            final place = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => PlacePickerPage(
                                          latLng: _locationData != null
                                              ? LatLng(_locationData?.latitude,
                                                  _locationData?.longitude)
                                              : null,
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
              GridView.builder(
                itemCount:
                    _images.values.length < 4 ? _images.values.length + 1 : 4,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final isOdd = index % 2 == 0;

                  print("index $index");
                  print(_images.values.length);

                  return GestureDetector(
                    onTap: () async {
                      final f = await getImage();
                      if (f != null) {
                        _images[index] = f;
                        setState(() {});
                      }
                    },
                    child: Container(
//                      color: Color(0xFF363636),
//                    padding: const EdgeInsets.all(4),
                      margin: EdgeInsets.fromLTRB(isOdd ? 0 : 8, 8, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          image: _images.containsKey(index)
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(_images[index]))
                              : null,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 1),
                          ]),
                       child: _images.containsKey(index)
                          ? null
                          : Center(
                              child: Icon(_images.values.length == index
                                  ? Icons.add
                                  : Icons.photo)),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.maxFinite,
                height: 56,
                child: OutlineButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Text('Отправить', textAlign: TextAlign.center),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<File> getImage() async {
    final picker = ImagePicker();

    File _file;

    ImageSource imageSource = ImageSource.camera;

    final source = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: SizedBox(
                width: 80,
                height: 80,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                ),
              ),
            ));

    if (source is ImageSource) {
      final f = await picker.getImage(source: source);

      if (f != null && File(f.path).existsSync()) _file = File(f.path);
    }

    return _file;
  }
}

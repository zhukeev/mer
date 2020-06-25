import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:location/location.dart';
import 'package:mer/place_picker_page.dart';

class NewRequestPage extends StatefulWidget {
  @override
  _NewRequestPageState createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {
  final descriptionTEC = TextEditingController();
  final addressTEC = TextEditingController();

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;



  File _file;

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
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Neumorphic(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: addressTEC,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                  decoration: InputDecoration(labelText: 'Адесс'),
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
                  validator: (val) => val.isEmpty ? 'Обязательное поле' : null,
                  decoration: InputDecoration(labelText: 'Описание'),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 56,
                    child: NeumorphicButton(
                      child: Center(
                        child: Text('Показать адрес на карте',
                            textAlign: TextAlign.center),
                      ),
                      onPressed: () async {
                        final place = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => PlacePickerPage()));
                        if(place!=null){}
                      },
                    ),
                  ),
                  Expanded(
                      child: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () async {
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
                    },
                  ))
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 56,
                    child: NeumorphicButton(
                      child: Center(
                        child: Text('Прикрепить файл',
                            textAlign: TextAlign.center),
                      ),
                      onPressed: () async {
                        _file = await FilePicker.getFile(type: FileType.image);

                        setState(() {});
                      },
                    ),
                  ),
                  _file != null
                      ? Expanded(
                          child: Image.file(
                          _file,
                          fit: BoxFit.cover,
                        ))
                      : Container()
                ],
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
}

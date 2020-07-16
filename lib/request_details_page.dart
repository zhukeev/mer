import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mer/model/req.dart';

import 'home_page.dart';

class RequestDetailsPage extends StatelessWidget {
  final Request request;

  RequestDetailsPage(this.request);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Детали заявки', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.maxFinite,
              height: 200,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Статус:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Создана:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Дата создания:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Описание:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Адрес:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Направлено:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Завершено:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildStatus(RequestStatus.values[
                            Random().nextInt(RequestStatus.values.length)]),
                        Text('someuser12@mail.com'),
                        Text(DateFormat("yyyy-MM-dd h:mm:ss")
                            .format(DateTime.now())),
                        Text('Проблема с дорогами'),
                        Text('Белинского/Московская'),
                        Text('Тазалык,Главарчитект,УМС'),
                        Text('47 %'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
        Text(
          'Местоположение:',
          style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            SizedBox(
              height: 200,
              child: GoogleMap(
                mapType: MapType.normal,
                padding: const EdgeInsets.all(32),
                myLocationButtonEnabled: true,
                onTap: (latLng) => Navigator.of(context).pop(latLng),
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(42.8767897, 74.4517753), zoom: 15),
                onMapCreated: (GoogleMapController controller) {},
              ),
            ),
            ListView.builder(

              itemCount: 10,
                shrinkWrap: true,
                itemBuilder: (_,index){
           return   Container(
             decoration: BoxDecoration(
                 color: Colors.white,
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.3),
                     spreadRadius: 1,
                     blurRadius: 1,
                   ),
                 ],
                 borderRadius: BorderRadius.circular(5)),
             child: Column(
               children: <Widget>[
                 buildStatus(RequestStatus.values[
                 Random().nextInt(RequestStatus.values.length)]),

               ],
             ),
           );
            }),
          ],
        ),
      ),
    );
  }

  Text buildStatus(RequestStatus status) {
    String text;
    Color color;

    switch (status) {
      case RequestStatus.New:
        color = Color(0XFF24C6C8);
        text = "Новый";
        break;
      case RequestStatus.InProgress:
        color = Color(0XFF1D84C6);
        text = "На выполнении";
        break;
      case RequestStatus.Canceled:
        color = Color(0XFF1BB394);
        text = "Завершено";
        break;
      case RequestStatus.Completed:
        color = Color(0XFFED5666);
        text = "Отклонено";
        break;
      case RequestStatus.ReadyToFinish:
        color = Color(0XFFF8AC5A);
        text = "Готово к завершению";
        break;
    }
    return Text(text, style: TextStyle(color: color));
  }
}

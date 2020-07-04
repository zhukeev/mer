import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

enum RequestStatus { New, InProgress, Completed, Canceled, ReadyToFinish }

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  TabController _tabController;

  final asds = [
    'adsfwef wef we fwea fwe fwe f adsfwef wef we fwea fwe fwe fwe fwea fwe fwe f adsfwef wef we fwea fwe fwe f',
    'adsfwef wef we fwea fwe fwe f wef we fwea fwe fwe f wef we fwea fwe fwe f wef we fwea fwe fwe f',
    'adsfwef wef we fweafwef wef we fweafwef wef we fweafwef wef we fwea fwe fwe f',
    'adsfwef wef we fwea fwe fwewef we fwea fwe fwesfwef wef we fwea fwe fwewef we fwea fwe fwesfwef wef we fwea fwe fwewef we fwea fwe fwefwef wef we fwea fwe fwewef we fwea fwe fwesfwef wef we fwea fwe fwewef we fwea fwe fwefwef wef we fwea fwe fwewef we fwea fwe fwesfwef wef we fwea fwe fwewef we fwea fwe fwesfwef wef we fwea fwe fwewef we fwea fwe fwewef we fwea fwe fwe f',
    'adsfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwesfwef wef we fwea fwe fwe f',
    'adsfwef wef we fwea fwe fwe f',
    'adsfwef wef we fwwef wef we fwwef wef we fwwef wef fwef wef we fwwef wef we fwwef wef we fwwef wef fwef wef we fwwef wef we fwwef wef we fwwef wef fwef wef we fwwef wef we fwwef wef we fwwef wef fwef wef we fwwef wef we fwwef wef we fwwef wef fwef wef we fwwef wef we fwwef wef we fwwef wef fwef wef we fwwef wef we fwwef wef we fwwef wef we fwwef wef we fwwef wef we fwea fwe fwe f',
    'adsfwef wef we fwea fwe fwe f',
    'adsfwef wef we fwea fwe dsfwef wef we fwea fwe dsfwef wef we fwea fwe sfwef wef we fwea fwe dsfwef wef we fwea fwe dsfwef wef we fwea fwe sfwef wef we fwea fwe dsfwef wef we fwea fwe dsfwef wef we fwea fwe sfwef wef we fwea fwe dsfwef wef we fwea fwe dsfwef wef we fwea fwe sfwef wef we fwea fwe dsfwef wef we fwea fwe dsfwef wef we fwea fwe dsfwef wef we fwea fwe fwe f',
    'adsfwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe ffwef wef we fwea fwe fwe f',
  ];

  String upperCaseFirst(String s) =>
      (s ?? '').length < 1 ? '' : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0 + 10),
        child: ListView.builder(
            itemCount: 30,
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, i) {
              final month = Jiffy([2019, i % 12, 19]).format("MMMM");
              return i % 5 == 0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        upperCaseFirst(month),
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 1),
                                  ],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.notification_important,
                                      color: Theme.of(context).accentColor),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Some title',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Flexible(
                                          child: Text(asds[i % asds.length]),
                                        ),
                                        Text(
                                          DateFormat("dd/MM/yyyy h:mm").format(
                                              DateTime.now().subtract(Duration(
                                                  seconds: Random()
                                                      .nextInt(100000000)))),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    );
            }),
      ),
    );
  }
}

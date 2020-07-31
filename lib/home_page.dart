import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mer/request_details_page.dart';

enum RequestStatus { New, InProgress, Completed, Canceled, ReadyToFinish }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setLocale();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dark = NeumorphicTheme.of(context).isUsingDark;

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 24),
          TabBar(
              labelColor: Theme.of(context).textTheme.caption.color,
              controller: _tabController,
              tabs: [Tab(text: 'Мои заявки'), Tab(text: 'Заявки')]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                    itemCount: 30,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemExtent: 150,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>RequestDetailsPage(null)));
                        },
                        child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
//                                border: Border.all(color: Colors.grey),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Column(
                                            children: <Widget>[
                                              Flexible(
                                                child: new Text(
                                                  'Text largeeeeeeeeeeda sfgwjEGFKW jwge JFGEWFYWg kfyugw ugyfuwfukywg fukwygeukfgwuGFKUWyg jyeg jkfgweJFYGWjeygf kjwyeg kyf gwUYEF Kweg  gweifgweyg ufgweeeeeeeeeeeee asdg fkyg skyfg kjwesygf kuwyeg ',
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: CachedNetworkImage(
                                            height: 80,
                                            imageUrl:
                                                'https://picsum.photos/200/'),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          DateFormat("dd/MM/yyyy h:mm").format(
                                              DateTime.now().subtract(Duration(
                                                  seconds: Random()
                                                      .nextInt(100000000)))),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )),
                                    buildStatus(RequestStatus.values[Random()
                                        .nextInt(RequestStatus.values.length)]),
                                  ],
                                ),
                              ],
                            )),
                      );
                    }),
                ListView.builder(
                    itemCount: 30,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemExtent: 150,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
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
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Column(
                                        children: <Widget>[
                                          Flexible(
                                            child: new Text(
                                              'Text largeeeeeeeeeeda sfgwjEGFKW jwge JFGEWFYWg kfyugw ugyfuwfukywg fukwygeukfgwuGFKUWyg jyeg jkfgweJFYGWjeygf kjwyeg kyf gwUYEF Kweg  gweifgweyg ufgweeeeeeeeeeeee asdg fkyg skyfg kjwesygf kuwyeg ',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                        height: 80,
                                        imageUrl: 'https://picsum.photos/200/'),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.person_outline),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('Anonymous${Random().nextInt(100)} \n' +
                                            Jiffy(
                                                    DateFormat(
                                                            "yyyy-MM-dd h:mm:ss")
                                                        .format(DateTime.now()
                                                            .subtract(Duration(
                                                                seconds: Random()
                                                                    .nextInt(
                                                                        100000000)))),
                                                    "yyyy-MM-dd h:mm:ss")
                                                .fromNow())
                                      ],
                                    ),
                                  ],
                                )),
                                buildStatus(RequestStatus.values[Random()
                                    .nextInt(RequestStatus.values.length)]),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
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

  void setLocale() async {
    await Jiffy.locale("ru");
  }
}

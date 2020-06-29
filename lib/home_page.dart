import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mer/google_sign_in_service.dart';
import 'package:mer/new_request_page.dart';
import 'package:mer/sign_in_page.dart';
import 'package:mer/statistic_page.dart';

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dark = NeumorphicTheme.of(context).isUsingDark;

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Text('Главная'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (val) async {
              switch (val) {
                case 'Статистика':
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => StatisticPage()));
                  break;
                case 'Выйти':
                  {
                    GoogleSignInService s = GoogleSignInService(
                        account: (GoogleSignInAccount value) {});

                    await s.signOut();

                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => SignInPage()));
                  }

                  break;
                case 'О программе':
                  break;
              }

              print(val);
            },
            itemBuilder: (BuildContext context) {
              return {
                'Включить темную тему',
                'Статистика',
                'О программе',
                'Выйти'
              }.map((String choice) {
                return choice == 'Включить темную тему'
                    ? PopupMenuItem<String>(
                        value: choice,
                        child: SwitchListTile(
                            value: dark,
                            onChanged: (val) {
                              setState(() {
                                NeumorphicTheme.of(context).themeMode =
                                    !val ? ThemeMode.light : ThemeMode.dark;
                              });
                            }))
                    : PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TabBar(
              labelColor: Theme.of(context).textTheme.caption.color,
              controller: _tabController,
              tabs: [
                new Tab(
                    icon: new Icon(FontAwesomeIcons.fileUpload),
                    text: 'Мои заявки'),
                new Tab(icon: new Icon(Icons.assignment), text: 'Заявки'),
              ]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Stack(
                  children: <Widget>[
                    /*Opacity(
                      opacity: 0.5,
                      child: SizedBox.expand(
                        child: Hero(
                          tag: 'assets/images/bishkek.svg',
                          child: SvgPicture.asset('assets/images/bishkek.svg',
                              colorBlendMode: BlendMode.color,
                              allowDrawingOutsideViewBox: true,
                              height: 120),
                        ),
                      ),
                    ),*/
                    ListView.builder(
                        itemCount: 30,
                        shrinkWrap: true,
                        cacheExtent: 100,
                        itemExtent: 150,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onLongPress: () {
                              HapticFeedback.vibrate();

                              showSnackbar(context);
                            },
                            child: Neumorphic(
                                margin: const EdgeInsets.all(8),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text('title'),
                                                      Text('status',
                                                          style: TextStyle(
                                                              color: Colors
                                                                      .primaries[
                                                                  Random().nextInt(Colors
                                                                      .primaries
                                                                      .length)])),
                                                    ],
                                                  ),
                                                  Text(
                                                      'dat ke fkweh wkeuh gluerhgl eruhglkuerhg kuhearl ghlearuhgaergluaehrguklah erla'),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(Icons
                                                                  .person_outline),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                  'Anonymous${Random().nextInt(100)}')
                                                            ],
                                                          ),
                                                          Text(DateFormat(
                                                                  'dd.MM.yyyy')
                                                              .format(DateTime
                                                                  .now())),
                                                        ],
                                                      )),
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .keyboard_arrow_down,
                                                              color:
                                                                  Colors.red),
                                                          onPressed: null),
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .keyboard_arrow_up,
                                                            color: Colors
                                                                .lightGreen,
                                                          ),
                                                          onPressed: null),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Image.network(
                                              'https://picsum.photos/200/'),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }),
                  ],
                ),
                ListView.builder(
                    itemCount: 30,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onLongPress: () {
                          HapticFeedback.vibrate();

                          showSnackbar(context);
                        },
                        child: Container(),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => NewRequestPage())),
        child: Icon(Icons.add),
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

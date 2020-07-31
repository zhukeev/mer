import 'dart:math';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mer/google_sign_in_service.dart';
import 'package:mer/home_page.dart';
import 'package:mer/new_request_page.dart';
import 'package:mer/notifications_page.dart';
import 'package:mer/sign_in_page.dart';
import 'package:mer/statistic_page.dart';

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  PageController _myPage = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dark = NeumorphicTheme.of(context).isUsingDark;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 50,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 75,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildPadding(index: 0, title: "Заявки", icon: Icons.list),
              buildPadding(
                  index: 1, title: "Статистика", icon: Icons.show_chart),
              SizedBox(width: 16),
              buildPadding(
                  index: 2, title: "Оповещения", icon: Icons.notifications),
              buildPadding(index: 3, title: "Настройки", icon: Icons.settings),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        onPageChanged: (page) {
          print('Page Changes to index $page');
          currentPage = page;
        },
        children: <Widget>[
          HomePage(),
          StatisticPage(),
          NotificationsPage(),
          Center(
            child: Container(
              child: Text('Empty Body 3'),
            ),
          )
        ],
        physics:
            NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
      ),
      floatingActionButton: Container(
        height: 65.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => NewRequestPage())),
            child: Icon(Icons.add, color: Colors.white),
            // elevation: 5.0,
          ),
        ),
      ),
    );
  }

  GestureDetector buildPadding({int index, String title, IconData icon}) {
    final isSelected = currentPage == index;
    return GestureDetector(
      onTap: () {
        if (!isSelected)
          setState(() {
            _myPage.jumpToPage(index);
          });
      },
      child: Container(
        padding: EdgeInsets.only(top: 16),
        width: 80,
        height: 70,
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey,
            ),
            Text(
              title,
              style: isSelected
                  ? TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                  : TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
            )
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

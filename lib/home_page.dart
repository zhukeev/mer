import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neumorphic/neumorphic.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> menuItems = [
    'Все заказы',
    'Новый заказ',
    'Погрузка',
    'Выгрузка',
    'Местоположение',
    'Нет местоположения',
    'Документ загружен',
    'Будет доставлен через сутки'
  ];

  String selectedMenu = 'Все заказы';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Главная'),
          actions: <Widget>[
            PopupMenuButton<String>(
                icon: Icon(Icons.sort),
                initialValue: selectedMenu,
                onSelected: (selected) {
                  setState(() {
                    selectedMenu = selected;
                  });

                  print('selected $selected');
                },
                itemBuilder: (context) {
                  return menuItems.map((item) {
                    return PopupMenuItem<String>(
                      child: Text(
                        item,
                        style: TextStyle(
                            fontWeight:
                                item == selectedMenu ? FontWeight.bold : null),
                      ),
                      value: item,
                    );
                  }).toList();
                }),
          ],
        ),
        body: SafeArea(
          child: ListView.builder(
              itemCount: 30,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onLongPress: () {
                    HapticFeedback.vibrate();

                    showSnackbar(context);
                  },
                  child: NeuCard(
                      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                      margin:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
//                      margin: const EdgeInsets.all(16),
                      decoration: NeumorphicDecoration(
                          borderRadius: BorderRadius.circular(5)),
                      curveType: CurveType.flat,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Заказ №9379992 будет доставлен через сутки',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                ),
                                Text(
                                  '2623 Railroad St Orange, Kansas 78577 ',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                );
              }),
        ),);
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

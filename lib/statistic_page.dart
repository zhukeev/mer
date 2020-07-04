import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:mer/model/stat.dart';
import 'package:mp_chart/mp/chart/bar_chart.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/image_loader.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  final String url = 'https://covid.kg/';

  final Map<String, double> dataMap = {
    "Случаев заболевания": 0.0,
    "Болеют на текущий день": 0.0,
    "Выздоровело": 0.0,
    "Новых случаев заболевания на текущий день": 0.0,
    "Случаев смерти": 0.0,
  };

  bool init = false;

  var random = Random(1);
  int _count = 10;
  double _range = 100.0;

  StatisticData statisticData;
  var controller;

  Future<StatisticData> getStatisticData() async {
    final response = await http.get(url);

    dom.Document document = parser.parse(response.body);

    String dateText = document
        .getElementsByClassName('data-name ml-3 mb-3')[0]
        .text
        .substring(32);
    int allCases =
        int.parse(document.getElementsByClassName('data-active')[0].innerHtml);
    int todayCases =
        int.parse(document.getElementsByClassName('data-today')[0].innerHtml);
    int recovered = int.parse(
        document.getElementsByClassName('data-recovered')[0].innerHtml);
    int deaths =
        int.parse(document.getElementsByClassName('data-deatg')[0].innerHtml);

    dataMap.update("Случаев заболевания", (_) => allCases.toDouble());
    dataMap.update("Болеют на текущий день", (_) => todayCases.toDouble());
    dataMap.update("Выздоровело", (_) => recovered.toDouble());
    dataMap.update("Новых случаев заболевания на текущий день",
        (_) => todayCases.toDouble());
    dataMap.update("Случаев смерти", (_) => deaths.toDouble());

    return StatisticData(
      date: dateText,
      allCases: allCases,
      todayCases: todayCases,
      recovered: recovered,
      deaths: deaths,
    );
  }

  @override
  void didChangeDependencies() {
    if (!init) {
      _initController();
      _initBarData(_count, _range);

      init = true;
      getStatisticData().then((value) {
        print(value);
        statisticData = value;
        dataMap.putIfAbsent(
            "Случаев заболевания", () => value.allCases.toDouble());
        dataMap.putIfAbsent(
            "Болеют на текущий день", () => value.activeCases.toDouble());
        dataMap.putIfAbsent("Выздоровело", () => value.recovered.toDouble());
        dataMap.putIfAbsent("Новых случаев заболевания на текущий день",
            () => value.todayCases.toDouble());
        dataMap.putIfAbsent("Случаев смерти", () => value.deaths.toDouble());
        if (mounted) setState(() {});
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Заявка', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            bottom: 100,
            child: _initBarChart(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                          child: Slider(
                              value: _count.toDouble(),
                              min: 0,
                              max: 1500,
                              onChanged: (value) {
                                _count = value.toInt();
                                setState(() {});
                                _initBarData(_count, _range);
                              })),
                    ),
                    Container(
                        constraints:
                            BoxConstraints.expand(height: 50, width: 60),
                        padding: EdgeInsets.only(right: 15.0),
                        child: Center(
                            child: Text(
                          "$_count",
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorUtils.BLACK,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ))),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                          child: Slider(
                              value: _range,
                              min: 0,
                              max: 200,
                              onChanged: (value) {
                                _range = value;
                                _initBarData(_count, _range);
                              })),
                    ),
                    Container(
                        constraints:
                            BoxConstraints.expand(height: 50, width: 60),
                        padding: EdgeInsets.only(right: 15.0),
                        child: Center(
                            child: Text(
                          "${_range.toInt()}",
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorUtils.BLACK,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _initBarData(int count, double range) async {
    var img = await ImageLoader.loadImage('assets/images/star.png');
    List<BarEntry> values = List();

    for (int i = 0; i < count; i++) {
      double multi = (range + 1);
      double val = (random.nextDouble() * multi) + multi / 3;
      values.add(new BarEntry(x: i.toDouble(), y: val, icon: img));
    }

    BarDataSet set1;

    set1 = new BarDataSet(values, "Data Set");
    set1.setColors1(ColorUtils.VORDIPLOM_COLORS);
    set1.setDrawValues(false);

    List<IBarDataSet> dataSets = List();
    dataSets.add(set1);

    controller.data = BarData(dataSets);
    controller.data
      ..setValueTextSize(10)
      ..barWidth = 0.9;

    setState(() {});
  }

  void _initController() {
    var desc = Description()..enabled = false;
    controller = BarChartController(
      axisLeftSettingFunction: (axisLeft, controller) {
        axisLeft.drawGridLines = false;
      },
      legendSettingFunction: (legend, controller) {
        legend.enabled = false;
      },
      xAxisSettingFunction: (xAxis, controller) {
        xAxis
          ..position = XAxisPosition.BOTTOM
          ..drawGridLines = false;
      },
      drawGridBackground: false,
      dragXEnabled: true,
      dragYEnabled: true,
      scaleXEnabled: true,
      scaleYEnabled: true,
      pinchZoomEnabled: false,
      maxVisibleCount: 60,
      description: desc,
      fitBars: true,
    );
  }

  Widget _initBarChart() {
    var barChart = BarChart(controller);
    controller.animator
      ..reset()
      ..animateY1(1500);
    return barChart;
  }
}

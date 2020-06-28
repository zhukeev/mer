import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:mer/model/stat.dart';
import 'package:pie_chart/pie_chart.dart';

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

  StatisticData statisticData;

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
        setState(() {});
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Text('Статистика'),
      ),
      body: Neumorphic(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Text(statisticData?.date ?? ''),
              PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32.0,
                chartRadius: MediaQuery.of(context).size.width / 2.7,
                showChartValuesInPercentage: true,
                showChartValues: true,
                showChartValuesOutside: false,
                chartValueBackgroundColor: Colors.grey[200],
                colorList: [
                  Colors.red,
                  Colors.amber,
                  Colors.grey,
                  Colors.green,
                  Colors.blue
                ],
                showLegends: true,
                legendPosition: LegendPosition.right,
                decimalPlaces: 1,
                showChartValueLabel: true,
                initialAngle: 0,
                chartValueStyle: defaultChartValueStyle.copyWith(
                  color: Colors.blueGrey[900].withOpacity(0.9),
                ),
                chartType: ChartType.disc,
              ),
              Text("""
    Случаев заболевания: ${statisticData?.allCases ?? ''},
    Болеют на текущий день: ${statisticData?.activeCases ?? ''},
    Выздоровело: ${statisticData?.recovered ?? ''},
    Новых случаев заболевания на текущий день: ${statisticData?.todayCases ?? ''},
    Случаев смерти: ${statisticData?.deaths ?? ''},
              """)
            ],
          )),
    );
  }
}

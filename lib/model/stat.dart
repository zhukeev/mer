
import 'package:flutter/foundation.dart';

class StatisticData {
  final String date;
  final int allCases;
  final int todayCases;
  final int recovered;
  final int deaths;
  int activeCases;

  StatisticData({
    @required this.date,
    @required this.allCases,
    @required this.todayCases,
    @required this.recovered,
    @required this.deaths,
  }) {
    activeCases = allCases - (recovered + deaths);
  }

  @override
  String toString() {
    return 'StatisticData{date: $date, allCases: $allCases, todayCases: $todayCases, recovered: $recovered, deaths: $deaths, activeCases: $activeCases}';
  }
}
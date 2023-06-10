import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/Header.dart';
import '../components/Footer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../features/MasterData.dart';
import '../features/TaskData.dart';
import '../features/SummaryData.dart';
import '../features/Util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({super.key});

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          DateTime date = DateTime.now();
          String text = DateFormat('EEE').format(date.subtract(Duration(days: 7 - value.toInt())));
          return Text(text);
        },
      );

  @override
  Widget build(BuildContext context) {
    final names = LangPackage().getNameString();
    final MasterData _masterData = context.watch<MasterData>();
    final TaskData _taskData = context.watch<TaskData>();
    final SummaryData _summaryData = context.watch<SummaryData>();
    _summaryData.setSummaryData(_masterData.getMasterList(), _taskData.getTaskList());
    final _weeklyData = _summaryData.getWeeklyTaskSummary();

    return Scaffold(
      appBar: const Header(title: 'Housework Manager'),
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          height: 100.0,
          child: Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text(names['line_title'], style: TextStyle(fontSize: 20.0)))),
        ),
        Container(
          height: 300.0,
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: LineChart(
                // 折線グラフ
                LineChartData(
                    // 折れ線グラフデータ
                    minX: 0, // x 軸の最小 x を取得します。null の場合、値は入力 lineBars から読み取られます
                    minY: 0, // y 軸の最小 y を取得します。null の場合、値は入力 lineBars から読み取られます
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                          // 線を表示するためのデータ
                          isCurved: false,
                          barWidth: 3.0, // 線の幅
                          color: Colors.blueAccent, // 線の色
                          spots: _weeklyData['husbandLine']),
                      LineChartBarData(
                          // 線を表示するためのデータ
                          isCurved: false,
                          barWidth: 3.0, // 線の幅
                          color: Colors.pinkAccent, // 線の色
                          spots: _weeklyData['wifeLine']),
                    ]),
                swapAnimationDuration: Duration(milliseconds: 150),
                swapAnimationCurve: Curves.linear,
              )),
        ),
        Container(
          height: 100.0,
          child: Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text(names['pie_title'], style: TextStyle(fontSize: 20.0)))),
        ),
        Container(
            height: 300.0,
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: 270,
                    sections: [
                      PieChartSectionData(
                          color: Colors.blueAccent,
                          value: _weeklyData['husbandTotal'],
                          titlePositionPercentageOffset: 0.4,
                          title: "${names['husband']} (${_weeklyData['husbandTotal']})",
                          titleStyle: TextStyle(fontSize: 16),
                          radius: 140),
                      PieChartSectionData(
                          color: Colors.pinkAccent,
                          value: _weeklyData['wifeTotal'],
                          titlePositionPercentageOffset: 0.4,
                          title: "${names['wife']} (${_weeklyData['wifeTotal']})",
                          titleStyle: TextStyle(fontSize: 16),
                          radius: 140)
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                  ),
                )))
      ])),
      bottomNavigationBar: const Footer(current: 0),
    );
  }
}

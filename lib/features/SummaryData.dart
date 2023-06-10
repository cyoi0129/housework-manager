import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import '../features/MasterData.dart';
import '../features/TaskData.dart';

class SummaryData extends ChangeNotifier {
  late List<TaskModel> _taskList;
  late List<MasterModel> _masterList;
  final DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  final DateTime _endDate = DateTime.now().subtract(Duration(days: 1));

  setSummaryData(List<MasterModel> masterData, List<TaskModel> taskData) {
    _masterList = masterData;
    _taskList = taskData;
  }

  MasterModel _getMasterItem(int target) {
    return _masterList.firstWhere((master) => master.id == target);
  }

  List<TaskModel> _getTargetTasks() {
    List<String> targetDays = [];
    for (int i = 0; i < 6; i++){
      targetDays.add((_startDate.day.toInt() + i).toString());
    }
    List<TaskModel> targetTasks = _taskList.where((TaskModel task) => DateTime.parse(task.start).isBefore(_startDate) && DateTime.parse(task.end).isAfter(_endDate)).toList();
    targetTasks = targetTasks.where((TaskModel task) => _getMasterItem(task.id).type != 'monthly' || targetDays.contains(task.start.split(RegExp(r'-.*?'))[2])).toList();
    return targetTasks;
  }

  getWeeklyTaskSummary() {
    List<TaskModel> tasks = _getTargetTasks();
    List husbandList = [];
    List wifeList = [];
    for (int i = 0; i < 6; i++) {
      int husbandPoints = 0;
      int wifePoints = 0;
      for (TaskModel task in tasks) {
        if (_getMasterItem(task.id).type == 'daily') {
          if (task.charge == 'husband') {
            husbandPoints += _getMasterItem(task.id).point;
          } else {
            wifePoints += _getMasterItem(task.id).point;
          }
        } else if (_getMasterItem(task.id).type == 'weekly') {
          if (DateTime.parse(task.start).weekday == DateTime.now().subtract(Duration(days: 7-i)).weekday) {
            if (task.charge == 'husband') {
              husbandPoints += _getMasterItem(task.id).point;
            } else {
              wifePoints += _getMasterItem(task.id).point;
            }
          }
        } else if (_getMasterItem(task.id).type == 'monthly') {
          if (DateTime.parse(task.start).day == DateTime.now().subtract(Duration(days: 7-i)).day) {
            if (task.charge == 'husband') {
              husbandPoints += _getMasterItem(task.id).point;
            } else {
              wifePoints += _getMasterItem(task.id).point;
            }
          }
        }
      }
      husbandList.add(husbandPoints);
      wifeList.add(wifePoints);
    }

    List<FlSpot> husbandLine = husbandList.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();
    List<FlSpot> wifeLine = wifeList.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();
    return {
      'husbandLine': husbandLine,
      'wifeLine': wifeLine,
      'husbandTotal': husbandList.reduce((a, b) => a + b).toDouble(),
      'wifeTotal': wifeList.reduce((a, b) => a + b).toDouble()
    };
  }
}

class CalendarData {
  TaskData taskData;
  MasterData masterData;
  DateTime date = DateTime.now();
  CalendarData({required this.taskData, required this.masterData});
}
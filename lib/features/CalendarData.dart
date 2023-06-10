import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import '../features/MasterData.dart';
import '../features/TaskData.dart';
import '../features/Util.dart';

class CalendarModel extends ChangeNotifier {
  final names = LangPackage().getNameString();
  List<TaskModel> _taskList = [];
  List<MasterModel> _masterList = [];
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};

  MasterModel _getMasterItem(int target) {
    return _masterList.firstWhere((master) => master.id == target);
  }

  void _addEvents(TaskModel task, String type) {
    late DateTime targetDate;
    late int duration;
    late int period;
    DateTime start = DateTime.parse(task.start);
    DateTime end = DateTime.parse(task.end);
    if (type == 'monthly') {
      duration = start.day - 1;
      period = (end.difference(start).inDays / 30).toInt();
    } else if (type == 'weekly') {
      duration = 7;
      period = (end.difference(start).inDays / 7).toInt();
    } else if (type == 'daily') {
      duration = 1;
      period = end.difference(start).inDays.toInt();
    } else if (type == 'weekday') {
      duration = 1;
      period = end.difference(start).inDays.toInt();
    } else if (type == 'weekend') {
      duration = 1;
      period = end.difference(start).inDays.toInt();
    }else if (type == 'shot') {
      duration = 0;
      period = 1;
    }
    for (int i = 0; i < period; i++) {
      if (type == 'monthly') {
        targetDate = DateTime(start.year, start.month + i, 1).add(Duration(days: duration));
      } else {
        targetDate = start.add(Duration(days: duration * i));
      }
      if ((type == 'weekday' && targetDate.weekday > 5) || (type == 'weekend' && targetDate.weekday < 6)) continue;
      DateTime key = DateTime.utc(targetDate.year, targetDate.month, targetDate.day);
      String value = '[${names[task.charge]}]: ${_getMasterItem(task.id).name}';
      if (_events.containsKey(key)) {
        if (!_events[key]!.contains(value)) {
          _events[key]?.add(value);
        }
      } else {
        _events[key] = [value];
      }
    }
  }

  void _setEventData() {
    for(TaskModel task in _taskList) {
      _addEvents(task, _getMasterItem(task.id).type);
    }
  }

  setCalendarEvents(List<MasterModel> masterData, List<TaskModel> taskData) {
    _masterList = masterData;
    _taskList = taskData;
    _setEventData();
  }

  List getEventForDay(DateTime day) {
    return _events[day] ?? [];
  }

  DateTime getFocusedDay() {
    return _focusedDay;
  }

  DateTime getSelectedDay() {
    return _selectedDay;
  }

  CalendarFormat getCalendarFormat() {
    return _calendarFormat;
  }

  getCurrentEvents() {
    return getEventForDay(_selectedDay);
  }

  void setFocusedDay(DateTime date) {
    _focusedDay = date;
  }

  void setSelectedDay(DateTime date) {
    if (date != _focusedDay) {
      _selectedDay = date;
      notifyListeners();
    }
  }

  void setCalendarFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }
}

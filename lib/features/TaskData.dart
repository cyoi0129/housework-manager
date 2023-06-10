import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskData extends ChangeNotifier {
  final baseUrl = 'http://localhost:1234';
  late User? _user;
  late String? _userID;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('housework');
  List<TaskModel> _tasks = [];

  TaskData() {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userID = _user?.uid;
      fetchTaskData();
    }
  }

  setTaskData() {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userID = _user?.uid;
      fetchTaskData();
    }
    notifyListeners();
  }

  Future fetchTaskData() async {
    final response = await dbRef.child(_userID.toString()).child('task').child('data').get();
    _tasks = (response.value as List<dynamic>).map((item) => TaskModel(item['id'], item['master'], item['charge'], item['start'], item['end'])).toList();
    notifyListeners();
  }

  // Future fetchTaskData() async {
  //   final response = await http.get(Uri.parse('${baseUrl}/task'));
  //   if (response.statusCode != 200) {
  //     throw Exception('Task API connection failed!');
  //   }
  //   final List<dynamic> json = jsonDecode(response.body)['data'];
  //   _tasks = json.map((item) => TaskModel(item['id'], item['master'], item['charge'], item['start'], item['end'])).toList();
  //   notifyListeners();
  // }

  List<TaskModel> getTaskList() {
    return _tasks;
  }

  TaskModel getTaskItem(int target) {
    return _tasks.firstWhere((task) => task.id == target);
  }

  void setTaskItem(TaskModel taskData) {
    // Post API
    _tasks.firstWhere((task) => task.id == taskData.id).master = taskData.master;
    _tasks.firstWhere((task) => task.id == taskData.id).charge = taskData.charge;
    _tasks.firstWhere((task) => task.id == taskData.id).start = taskData.start;
    _tasks.firstWhere((task) => task.id == taskData.id).end = taskData.end;
    notifyListeners();
  }

  void addTaskItem(TaskModel taskData) {
    // Post API
    TaskModel newTask = taskData;
    newTask.id = _tasks.map((item) => item.id).toList().reduce(max) + 1;
    _tasks.add(taskData);
    notifyListeners();
  }

  void removeTaskItem (int target) {
    // Post API
    _tasks.remove(_tasks.firstWhere((task) => task.id == target));
    notifyListeners();
  }
}

class TaskEditModel extends ChangeNotifier {
  int _id = 0;
  int _master = 1;
  String _charge = 'husband';
  String _start = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _end = DateFormat('yyyy-MM-dd').format(DateTime.now());

  setTaskEditModel(TaskModel data) {
    _id = data.id;
    _master = data.master;
    _charge = data.charge;
    _start = data.start;
    _end = data.end;
  }

  void changeMaster(int? value) {
    if (value != null) {
      _master = value;
    }
    notifyListeners();
  }

  void changeCharge(String? value) {
    if (value != null) {
      _charge = value;
    }
    notifyListeners();
  }

  void changeStart(String? value) {
    if (value != null) {
      _start = value;
    }
    notifyListeners();
  }

  void changeEnd(String? value) {
    if (value != null) {
      _end = value;
    }
    notifyListeners();
  }

  TaskModel getEditingTask() {
    return TaskModel(_id, _master, _charge, _start, _end);
  }
}

class TaskModel {
  int id;
  int master;
  String charge;
  String start;
  String end;
  TaskModel(this.id, this.master, this.charge, this.start, this.end);
}
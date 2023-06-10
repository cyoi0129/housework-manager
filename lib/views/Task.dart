import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/Header.dart';
import '../components/Footer.dart';
import 'package:intl/intl.dart';
import '../features/MasterData.dart';
import '../features/TaskData.dart';
import '../features/Util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskView extends StatelessWidget {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final names = LangPackage().getNameString();
    final TaskEditModel currentData = context.watch<TaskEditModel>();
    final MasterData masterData = context.watch<MasterData>();
    final TaskData _taskData = context.watch<TaskData>();

    void _changeDate(String target) async {
      final DateTime? picked =
          await showDatePicker(locale: const Locale("en"), context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now().add(Duration(days: 360)));
      if (picked != null) {
        String dateStr = DateFormat('yyyy-MM-dd').format(picked);
        if (target == 'end_date') {
          currentData.changeEnd(dateStr);
        } else {
          currentData.changeStart(dateStr);
        }
      }
    }

    void _saveTask() {
      if (currentData.getEditingTask().id == 0) {
        _taskData.addTaskItem(currentData.getEditingTask());
      } else {
        _taskData.setTaskItem(currentData.getEditingTask());
      }
      Navigator.of(context).pushNamed('/tasks');
    }

    return Scaffold(
      appBar: Header(title: 'Task Editor'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text('${currentData.getEditingTask().id == 0 ? names['new_task'] : 'ID: ' + currentData.getEditingTask().id.toString()}', style: TextStyle(fontSize: 24.0))),
          ),
          Column(children: [
            Padding(
                padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(names['type']),
                  DropdownButton(
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                    items: masterData.getMasterList().map((master) {
                      return DropdownMenuItem<int>(
                        value: master.id,
                        child: Text(master.name),
                      );
                    }).toList(),
                    onChanged: (value) => currentData.changeMaster(value),
                    value: currentData.getEditingTask().master,
                  )
                ])),
            Padding(
                padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(names['charge']),
                  DropdownButton(
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                    items: [
                      DropdownMenuItem(
                        child: Text(names['husband']),
                        value: 'husband',
                      ),
                      DropdownMenuItem(
                        child: Text(names['wife']),
                        value: 'wife',
                      ),
                    ],
                    onChanged: (value) => {currentData.changeCharge(value)},
                    value: currentData.getEditingTask().charge,
                  )
                ])),
            Padding(
                padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(names['start_date']),
                  OutlinedButton(
                    onPressed: () => _changeDate('start_date'),
                    child: Text('${currentData.getEditingTask().start}', style: TextStyle(color: Colors.black)),
                  )
                ])),
            Padding(
                padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(names['end_date']),
                  OutlinedButton(
                    onPressed: () => _changeDate('end_date'),
                    child: Text('${currentData.getEditingTask().end}', style: TextStyle(color: Colors.black)),
                  )
                ])),
            Padding(
                padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                child: SizedBox(
                    width: 160.0,
                    height: 40.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 24,
                      ),
                      onPressed: () {_saveTask();},
                      child: Text(names['save']),
                    )))
          ])
        ],
      ),
      bottomNavigationBar: Footer(current: 2),
    );
  }
}

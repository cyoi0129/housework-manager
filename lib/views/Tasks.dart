import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/Header.dart';
import '../components/Footer.dart';
import '../features/MasterData.dart';
import '../features/TaskData.dart';
import '../components/RemoveDialog.dart';
import '../features/Util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final names = LangPackage().getNameString();
    final MasterData _masterData = context.watch<MasterData>();
    final TaskData _taskData = context.watch<TaskData>();
    final TaskEditModel _targetData = context.watch<TaskEditModel>();
    final _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _taskData.setTaskData();
    }
    void _addTask() {
      Navigator.of(context).pushNamed('/task');
    }

    void _go2Task(TaskModel target) {
      _targetData.setTaskEditModel(target);
      Navigator.of(context).pushNamed('/task');
    }

    return Scaffold(
      appBar: const Header(title: 'Tasks'),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: _taskData.getTaskList().length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: ListTile(
                    onTap: () => {_go2Task(_taskData.getTaskList()[index])},
                    onLongPress: () => {
                          showDialog<void>(
                              context: context,
                              builder: (_) {
                                return RemoveDialog(type: 'task', target: _taskData.getTaskList()[index].id);
                              })
                        },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_masterData.getMasterItem(_taskData.getTaskList()[index].master).name}'),
                        Text('${names[_taskData.getTaskList()[index].charge]}'),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 16.0),
                        Text(' ${_taskData.getTaskList()[index].start} - ${_taskData.getTaskList()[index].end}'),
                      ],
                    )));
          }),
      floatingActionButton: FloatingActionButton(child: new Icon(Icons.add), onPressed: _addTask),
      bottomNavigationBar: Footer(current: 2),
    );
  }
}

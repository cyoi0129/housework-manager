import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/MasterData.dart';
import '../features/TaskData.dart';
import '../features/Util.dart';

class RemoveDialog extends StatelessWidget {
  String type;
  int target;
  RemoveDialog({super.key, required this.type, required this.target});

  @override
  Widget build(BuildContext context) {
    final MasterData _masterData = context.watch<MasterData>();
    final TaskData _taskData = context.watch<TaskData>();
    final names = LangPackage().getNameString();

    void _doRemove() {
      if (type == 'master') {
        _masterData.removeMasterItem(target);
      } else {
        _taskData.removeTaskItem(target);
      }
    }

    return AlertDialog(
      title: Text(names['confirm']),
      content: Text(names['confirm_txt']),
      actions: <Widget>[
        GestureDetector(
          child: Text(names['no']),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: Text(names['yes']),
          onTap: () {
            _doRemove();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
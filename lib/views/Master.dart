import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/Header.dart';
import '../components/Footer.dart';
import '../features/MasterData.dart';
import '../features/Util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MasterView extends StatelessWidget {
  const MasterView({super.key});

  @override
  Widget build(BuildContext context) {
    final names = LangPackage().getNameString();
    final MasterEditModel currentData = context.watch<MasterEditModel>();
    final MasterData masterData = context.watch<MasterData>();

    void _saveMaster() {
      if (currentData.getEditingMaster().id == 0) {
        masterData.addMasterItem(currentData.getEditingMaster());
      } else {
        masterData.setMasterItem(currentData.getEditingMaster());
      }
      Navigator.of(context).pushNamed('/masters');
    }

    return Scaffold(
      appBar: Header(title: 'Master Editor'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text('${currentData.getEditingMaster().id == 0 ? names['new_master'] : 'ID: ' + currentData.getEditingMaster().id.toString()}', style: TextStyle(fontSize: 24.0))),
          ),
          Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                  child: TextField(
                    controller: currentData.nameEditTextEditingController,
                    onChanged: (text) {
                      currentData.changeName(text);
                    },
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 80.0,
                      child: Text(names['type']),
                    ),
                    Container(
                        child: DropdownButton(
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                      items: [
                        DropdownMenuItem(
                          child: Text(names['shot']),
                          value: 'shot',
                        ),
                        DropdownMenuItem(
                          child: Text(names['daily']),
                          value: 'daily',
                        ),
                        DropdownMenuItem(
                          child: Text(names['weekly']),
                          value: 'weekly',
                        ),
                        DropdownMenuItem(
                          child: Text(names['monthly']),
                          value: 'monthly',
                        ),
                        DropdownMenuItem(
                          child: Text(names['weekday']),
                          value: 'weekday',
                        ),
                        DropdownMenuItem(
                          child: Text(names['weekend']),
                          value: 'weekend',
                        ),
                      ],
                      onChanged: (value) => currentData.changeType(value.toString()),
                      value: currentData.getEditingMaster().type,
                    )),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Row(children: [
                    Container(
                      width: 60.0,
                      child: Text(names['points']),
                    ),
                    Container(
                        child: Row(
                      children: [
                        Slider(
                          key: null,
                          onChanged: currentData.changePoint,
                          value: (currentData.getEditingMaster().point / 100).toDouble(),
                        ),
                        Text('${(currentData.getEditingMaster().point).toInt()}')
                      ],
                    ))
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
                        onPressed: () {
                          _saveMaster();
                        },
                        child: Text(names['save']),
                      )))
            ],
          )
        ],
      ),
      bottomNavigationBar: Footer(current: 3),
    );
  }
}

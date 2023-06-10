import 'package:flutter/material.dart';
import '../components/RemoveDialog.dart';
import 'package:provider/provider.dart';
import '../components/Header.dart';
import '../components/Footer.dart';
import '../features/MasterData.dart';
import '../features/Util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MastersView extends StatelessWidget {
  const MastersView({super.key});

  @override
  Widget build(BuildContext context) {
    final names = LangPackage().getNameString();
    final MasterData _masterData = context.watch<MasterData>();
    final MasterEditModel targetData = context.watch<MasterEditModel>();
    final _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _masterData.setMasterData();
    }
    void _addMaster() {
      MasterModel newMaster = MasterModel(0, 0, '', 'shot');
      targetData.setMasterEditModel(newMaster);
      Navigator.of(context).pushNamed('/master');
    }
    void _go2Master(MasterModel target) {
      targetData.setMasterEditModel(target);
      Navigator.of(context).pushNamed('/master');
    }
    return Scaffold(
      appBar: const Header(title: 'Master'),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: _masterData
              .getMasterList()
              .length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: ListTile(
                    onTap: () => {_go2Master(_masterData.getMasterList()[index])},
                    onLongPress: () => {
                    showDialog<void>(
                    context: context,
                    builder: (_) {
                      return RemoveDialog(type: 'master', target: _masterData.getMasterList()[index].id);
                    })
                },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_masterData.getMasterList()[index].name}'),
                        Text(
                          '${names[_masterData.getMasterList()[index].type]}',
                          style: TextStyle(color: Colors.black45, fontSize: 12.0),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.monetization_on, size: 16.0),
                        Text(' ${_masterData.getMasterList()[index].point}'),
                      ],
                    )));
          }),
      floatingActionButton: FloatingActionButton(child: new Icon(Icons.add), onPressed: _addMaster),
      bottomNavigationBar: Footer(current: 3),
    );
  }
}

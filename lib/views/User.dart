import 'package:flutter/material.dart';
import '../features/UserData.dart';
import '../components/Header.dart';
import '../components/Footer.dart';
import '../features/Util.dart';
import 'package:provider/provider.dart';
import '../features/MasterData.dart';
import '../features/TaskData.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final names = LangPackage().getNameString();
    final UserDataModel _userData = context.watch<UserDataModel>();
    final MasterData _masterData = context.watch<MasterData>();
    final TaskData _taskData = context.watch<TaskData>();
    final _user = FirebaseAuth.instance.currentUser;
    void _userLogin() {
      _userData.login();
      _masterData.setMasterData();
      _taskData.setTaskData();
    }

    void _userLogout() {
      _userData.logout();
    }

    return Scaffold(
      appBar: Header(title: 'User'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (_user == null)
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                      child: Center(child: Icon(Icons.login, size: 64.0)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(names['email'], style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                        child: TextField(
                          controller: _userData.emailEditTextEditingController,
                          onChanged: (text) {
                            _userData.changeEmail(text);
                          },
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(names['password'], style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                        child: TextField(
                          controller: _userData.passwordEditTextEditingController,
                          obscureText: true,
                          onChanged: (text) {
                            _userData.changePassword(text);
                          },
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: _userData.getLoginError() ? Text(names['error'], style: TextStyle(fontSize: 12.0, color: Colors.red)) : null,
                      ),
                    ),
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
                                _userLogin();
                              },
                              child: Text(names['login']),
                            )))
                  ],
                )
              : Column(children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
                    child: Center(child: Icon(Icons.person_pin, size: 64.0, color: Colors.orange)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                    child: Center(child: Text('${names['welcome'] + ' ' + _userData.getUserName()}', style: TextStyle(fontSize: 20.0))),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                      child: SizedBox(
                          width: 160.0,
                          height: 40.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 24,
                            ),
                            onPressed: () {
                              _userLogout();
                            },
                            child: Text(names['logout']),
                          )))
                ])
        ],
      ),
      bottomNavigationBar: Footer(current: 0),
    );
  }
}

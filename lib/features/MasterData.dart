import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MasterData extends ChangeNotifier {
  final baseUrl = 'http://localhost:1234';
  late User? _user;
  late String? _userID;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('housework');

  List<MasterModel> _masters = [];

  MasterData() {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userID = _user?.uid;
      fetchMasterData();
    }
  }

  setMasterData() {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userID = _user?.uid;
      fetchMasterData();
    }
    notifyListeners();
  }

  Future fetchMasterData() async {
    final response = await dbRef.child(_userID.toString()).child('master').child('data').get();
    _masters = (response.value as List<dynamic>).map((item) => MasterModel(item['id'], item['point'], item['name'], item['type'])).toList();
    notifyListeners();
  }

  // Future fetchMasterData() async {
  //   final response = await http.get(Uri.parse('${baseUrl}/master'));
  //   if (response.statusCode != 200) {
  //     throw Exception('Master API connection failed!');
  //   }
  //   final List<dynamic> json = jsonDecode(response.body)['data'];
  //   _masters = json.map((item) => MasterModel(item['id'], item['point'], item['name'], item['type'])).toList();
  //   notifyListeners();
  // }

  List<MasterModel> getMasterList() {
    return _masters;
  }

  MasterModel getMasterItem(int target) {
    return _masters.firstWhere((master) => master.id == target);
  }

  void setMasterItem(MasterModel masterData) {
    // Post API
    _masters.firstWhere((master) => master.id == masterData.id).name = masterData.name;
    _masters.firstWhere((master) => master.id == masterData.id).point = masterData.point;
    _masters.firstWhere((master) => master.id == masterData.id).type = masterData.type;
    notifyListeners();
  }

  void addMasterItem(MasterModel masterData) {
    // Post API
    MasterModel newMaster = masterData;
    newMaster.id = _masters.map((item) => item.id).toList().reduce(max) + 1;
    _masters.add(masterData);
    notifyListeners();
  }

  void removeMasterItem (int target) {
    // Post API
    _masters.remove(_masters.firstWhere((master) => master.id == target));
    notifyListeners();
  }
}


class MasterEditModel extends ChangeNotifier {
  int _id = 0;
  int _point = 0;
  String _name = '';
  String _type = 'shot';

  TextEditingController nameEditTextEditingController = TextEditingController();

  setMasterEditModel(MasterModel data) {
    _id = data.id;
    _point = data.point;
    _name = data.name;
    _type = data.type;
    nameEditTextEditingController = TextEditingController(text: data.name);
  }

  void changeName(String? value) {
    if (value != null) {
      _name = value;
    }
    notifyListeners();
  }

  void changePoint(double value) {
    _point = (value * 100).toInt();
    notifyListeners();
  }

  void changeType(String? value) {
    if (value != null) {
      _type = value;
    }
    notifyListeners();
  }

  MasterModel getEditingMaster() {
    return MasterModel(_id, _point, _name, _type);
  }

  @override
  void dispose() {
    nameEditTextEditingController.dispose();
    super.dispose();
  }
}

class MasterModel {
  int id;
  int point;
  String name;
  String type;
  MasterModel(this.id, this.point, this.name, this.type);
}
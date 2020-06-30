import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  saveId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('nid', id);
  }

  Future<int> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int id = prefs.getInt('nid');
    return id;
  }

  Future<int> getStudyDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int id = prefs.getInt('sduration');
    return id;
  }

  saveStudyDuration(int sduration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('sduration', sduration);
  }

  Future<int> getBreakDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int id = prefs.getInt('bduration');
    return id;
  }

  saveBreakDuration(int bduration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('bduration', bduration);
  }
}

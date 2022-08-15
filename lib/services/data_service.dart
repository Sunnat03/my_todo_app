import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DataService {
  late Directory directory;
  late File file;

  Future<DataService> instance() async {
    directory = await getApplicationSupportDirectory();
    file = _getFile();
    return this;
  }

  File _getFile() {
    String fileName = "/database.json";
    File file = File(directory.path + fileName);
    return file;
  }

  Future<void> _initFile() async {
    await file.writeAsString(jsonEncode({}));
  }

  Future<Map<String, dynamic>> _getAllData() async {
    String data = await file.readAsString();
    Map<String, dynamic> json = jsonDecode(data);
    return json;
  }

  Future<bool> setData(String key, Object value) async {
    // check value
    if(value is! int && value is! String && value is! bool && value is! List && value is! Map) return false;

    // check file
    bool isFileExist = await file.exists();
    if(!isFileExist) await _initFile();

    Map<String, dynamic> json = await _getAllData();
    json[key] = value;
    String data = jsonEncode(json);
    await file.writeAsString(data);
    return true;
  }

  Future<dynamic> getData(String key) async {
    String data = await file.readAsString();
    Map<String, dynamic> json = jsonDecode(data);
    if(json.containsKey(key)) {
      return json[key];
    }
    return null;
  }

  Future<dynamic> removeData(String key) async {
    String data = await file.readAsString();
    Map<String, dynamic> json = jsonDecode(data);
    if(!json.containsKey(key)) {
      return null;
    }
    String result = json.remove(key);
    data = jsonEncode(json);
    await file.writeAsString(data);
    return result;
  }

  Future<bool> clearAllData() async {
    await _initFile();
    return true;
  }
}
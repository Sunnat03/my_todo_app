import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_todo_app/services/util_service.dart';

import '../models/todo_model.dart';

class DBService {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox(ConstKeys.constKeyTodoOpenBox);
  }

  static void storeData(List<ToDo> todo) async {
    Box box = await Hive.openBox(ConstKeys.constKeyTodoOpenBox);
    await box.put(
        ConstKeys.constKeyTodoBox, todo.map((e) => e.toJson()).toList());
  }
}
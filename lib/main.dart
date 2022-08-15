import 'package:flutter/material.dart';
import 'package:my_todo_app/screens/detail_screen.dart';
import 'package:my_todo_app/screens/home_screen.dart';
import 'package:my_todo_app/screens/splash_screen.dart';
import 'package:my_todo_app/screens/task_detail_screen.dart';
import 'package:my_todo_app/screens/welcome_screen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      home: const HomeScreen(),
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        SplashScreen.id: (context) => const SplashScreen(),
        DetailScreen.id: (context) => const DetailScreen(),
        TaskDetailScreen.id: (context) => const TaskDetailScreen(),
      },
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_todo_app/screens/home_screen.dart';
import 'package:my_todo_app/screens/welcome_screen.dart';
class SplashScreen extends StatefulWidget {
  static const id = "splash_screen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  int _countIcon = 1;
  double _angle = 3.14;
  bool isLoad = true;

  _animatedIcon() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (isLoad) {
          _angle += 0.3;
          if (_angle >= 4 * pi) {
            _goto();
            timer.cancel();
          }
        } else {
          _angle += 0.3;
        }

        if (_angle > 10) {
          isLoad = true;
          _countIcon = 2;
        }
      });
    });
  }

  Future<void> _goto() async {
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }

  @override
  void initState() {
    super.initState();
    _animatedIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Transform.rotate(
          angle: _angle,
          child: Image.asset(
            "assets/icons/icon_$_countIcon.jpg",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }
}
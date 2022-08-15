import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_todo_app/screens/home_screen.dart';
import 'package:my_todo_app/services/theme_service.dart';
class WelcomeScreen extends StatefulWidget {
  static const id = "welcome_screen";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  void _goHome() {
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
                child: Lottie.asset("assets/lotties/succes.json",
                    repeat: false, reverse: false),
              ),
            ),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Welcome to\n\tUno To Do",
                      textAlign: TextAlign.center,
                      style: ThemeService.textStyle1(),
                    ),
                    Text(
                      "Start using the best To Do app",
                      style: ThemeService.textStyle2(),
                    ),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      onPressed: _goHome,
                      shape: const StadiumBorder(),
                      color: const Color(0xff5835E5),
                      child: Text(
                        "Get Started",
                        style: ThemeService.textStyle3(),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
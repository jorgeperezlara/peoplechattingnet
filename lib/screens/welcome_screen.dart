import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:peoplechattingnet/screens/login_screen.dart';
import 'package:peoplechattingnet/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:peoplechattingnet/constants.dart';
import 'package:peoplechattingnet/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();

  static String id = Screens.welcome.toString(); //el map es de tipo String.
  static String loginButton = HeroID.loginButton.toString();
  static String registrationButton = HeroID.registrationButton.toString();
  static String logoID = HeroID.logo.toString();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = ColorTween(begin: Colors.blue[50], end: Colors.white).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: WelcomeScreen.logoID,
                  child: Container(
                    child: Image.asset('images/peoplechat.png'),
                    height: controller.value * 100,
                  ),
                ),
                SizedBox(
                  child: ColorizeAnimatedTextKit(
                    text: ['People Chatting'],
                    isRepeatingAnimation: false,
                    colors: [Colors.black87, Colors.black12],
                    textStyle: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  width: 250,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            SizedBox(
              height: 48.0,
            ),
            buttonWidget(buttonColor: Colors.lightBlueAccent, onPressed: (){Navigator.pushNamed(context, LoginScreen.id);}, tag: WelcomeScreen.loginButton, text: 'Log in'),
            buttonWidget(buttonColor: Colors.blueAccent, onPressed: (){Navigator.pushNamed(context, RegistrationScreen.id);}, tag: WelcomeScreen.registrationButton, text: 'Sign up'),
          ],
        ),
      ),
    );
  }
}
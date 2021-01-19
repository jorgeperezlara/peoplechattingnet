import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:peoplechattingnet/screens/welcome_screen.dart';
import 'package:peoplechattingnet/screens/login_screen.dart';
import 'package:peoplechattingnet/screens/registration_screen.dart';
import 'package:peoplechattingnet/screens/chat_screen.dart';

void main() => runApp(PeopleChatting());

class PeopleChatting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      initialRoute: WelcomeScreen.id, //hacemos el map con el id asignado, así evitamos errores.
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id : (context) => ChatScreen(),
    }
    );
  }
}

import 'package:peoplechattingnet/constants.dart';
import 'package:peoplechattingnet/screens/chat_screen.dart';
import 'package:peoplechattingnet/screens/welcome_screen.dart';
import 'package:peoplechattingnet/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();

  static String id = Screens.login.toString(); //el map es de tipo String
}

class _LoginScreenState extends State<LoginScreen> {

  String userEmail;
  String userPassword;
  bool _showSpinner = false;

  void showSpinner(){
    setState(() {
      _showSpinner = true;
    });
  }
  void hideSpinner(){
    setState(() {
      _showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: WelcomeScreen.logoID,
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/peoplechatting.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextFieldSingin(hintText: 'Enter your username', emailType: true,
                  onChanged: (value) {
                    userEmail = value;
                }),
              SizedBox(
                height: 8.0,
              ),
              TextFieldSingin(hintText: 'Enter your password',obscureText: true,
                  onChanged: (value) {
                    userPassword = value;
                }),
              SizedBox(
                height: 24.0,
              ),
              buttonWidget(text: 'Log in', tag:  WelcomeScreen.loginButton, buttonColor: Colors.lightBlueAccent, onPressed: () async {
                showSpinner();
                FirebaseAuth _auth = FirebaseAuth.instance;
                try {
                  UserCredential userToken = await _auth
                      .signInWithEmailAndPassword(
                      email: userEmail, password: userPassword);
                  User user = userToken.user;
                  if(userToken != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al iniciar sesión. Compruebe las credenciales.')));
                  }
                  hideSpinner();
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al iniciar sesión. Compruebe la conexión a internet y que ha rellenado todos los campos.')));
                  hideSpinner();
                }
                }),
            ],
          ),
        ),
        inAsyncCall: _showSpinner,
      ),
    );
  }
}

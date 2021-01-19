import 'package:peoplechattingnet/constants.dart';
import 'package:peoplechattingnet/screens/chat_screen.dart';
import 'package:peoplechattingnet/screens/welcome_screen.dart';
import 'package:peoplechattingnet/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();

  static String id =
      Screens.registration.toString(); //el map es de tipo String.
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  
  String email;
  String password;
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
              TextFieldSingin(hintText: 'Enter your new email', emailType: true,
                  onChanged: (value) {
                  email = value;
                }),
              SizedBox(
                height: 8.0,
              ),
              TextFieldSingin(hintText: 'Enter your new password', obscureText: true,
                  onChanged: (value) {
                  password = value;
                }),
              SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: WelcomeScreen.registrationButton,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        showSpinner();
                        final _auth = FirebaseAuth.instance;
                        try{
                          final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                          if(newUser != null){
                            Navigator.pushNamed(context, ChatScreen.id);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ha habido un error, pruebe con otro usuario y con una contraseña mayor de 6 caracteres.')));
                          }
                          hideSpinner();
                        }
                        catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrarse. Compruebe su dirección email y que la contraseña es mayor de 6 caracteres.')));
                          hideSpinner();
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        inAsyncCall: _showSpinner,
      ),
    );
  }
}

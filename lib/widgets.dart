import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peoplechattingnet/constants.dart';
import 'package:flutter/material.dart';

class buttonWidget extends StatelessWidget {
  final Object tag;
  final Color buttonColor;
  final VoidCallback onPressed;
  final String text;

  const buttonWidget({
    Key key,
    this.tag,
    this.buttonColor,
    this.onPressed,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          elevation: 5.0,
          color: buttonColor,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldSingin extends StatelessWidget {
  final String hintText;
  final Function onChanged;
  final bool obscureText;
  final bool emailType;
  const TextFieldSingin({
    Key key,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.emailType = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextInputType inputType;
    if (emailType) {
      inputType = TextInputType.emailAddress;
    } else {
      inputType = TextInputType.text;
    }

    return TextField(
        obscureText: obscureText,
        keyboardType: inputType,
        onChanged: this.onChanged,
        decoration: kLoginInputDecoration.copyWith(hintText: hintText));
  }
}

class TextBubble extends StatelessWidget {
  String senderName;
  String messageText;
  bool itIsMe;
  TextBubble(this.messageText, this.senderName, this.itIsMe);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SenderText(senderName),
        SizedBox(height: 5),
        MessageWidget(messageText, itIsMe),
      ],
      crossAxisAlignment: itIsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    );
  }
}

class SenderText extends StatelessWidget {
  String text;
  SenderText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey),
    );
    ;
  }
}

class MessageWidget extends StatelessWidget {
  String text;
  bool itIsMe;
  MessageWidget(this.text, this.itIsMe);
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(text, style: TextStyle(color: Colors.white))),
        color: itIsMe ? Colors.lightBlueAccent : Colors.lightGreen,
        borderRadius: itIsMe ? kBubbleMe : kBubbleOther,
    elevation: 5);
  }
}

class MessageListBuilder extends StatelessWidget {
  const MessageListBuilder({
    Key key,
    @required FirebaseFirestore storeInstance,
    @required User user,
  }) : _storeInstance = storeInstance, _user = user, super(key: key);

  final FirebaseFirestore _storeInstance;
  final User _user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _storeInstance.collection('messages').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.lightBlueAccent),
          );
        }
        List<Widget> widgetList = [];
        for(int i = 0; i < snapshot.data.docs.length; i++){
          var messages = snapshot.data.docs.reversed.toList()[i];

          bool itIsMe = messages.data()['sender'] == _user.email;

          widgetList.add(SizedBox(height: 20));
          widgetList.add(TextBubble(messages.data()['text'], messages.data()['sender'], itIsMe));
          widgetList.add(SizedBox(height: 20));
        }
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
              reverse: true,
              children: widgetList,
              scrollDirection: Axis.vertical
          ),
        );
      },
    );
  }
}
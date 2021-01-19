import 'package:firebase_auth/firebase_auth.dart';
import 'package:peoplechattingnet/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:peoplechattingnet/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peoplechattingnet/widgets.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();

  static String id = Screens.chat.toString(); //el map es de tipo String.
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;
  String messageText;
  User _user;
  final _storeInstance = FirebaseFirestore.instance;
  final textController = TextEditingController();

  void loadUser(){
    if(_auth.currentUser != null){
      _user = _auth.currentUser;
      print(_user.email);
    }
  }

  Future<void> messageStreamFetcher() async {
    await for (var messagesStream in _storeInstance.collection('messages').snapshots()){
      for(var messages in messagesStream.docs){
        print(messages.data());
      }
    }
  }

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('PeopleChatting.net'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: MessageListBuilder(storeInstance: _storeInstance, user: _user),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _storeInstance.collection('messages').add({'text': messageText, 'sender': _user.email});
                      textController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ourland_native/models/constant.dart';
import 'package:ourland_native/models/user_model.dart';
import 'package:ourland_native/models/chat_model.dart';
import 'package:ourland_native/widgets/chat_message.dart';

//final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class ChatList extends StatelessWidget {
  final ValueListenable<Stream> chatStream; 
  final String parentId;
  final User user;
  final ScrollController listScrollController;
  Map<String, Colors> _colorMap;
  int lastColorIndex = -1;
  var listMessage;
  ChatList({Key key, @required this.chatStream, @required this.parentId, @required this.user, @required this.listScrollController}) : super(key: key) {
    this._colorMap = new Map<String, Colors>();
  }

  Widget buildItem(String messageId, Chat document, Function _onTap, BuildContext context) {
    Widget rv;
    rv = new ChatMessage(user: user, messageBody: document, parentId: this.parentId, messageId: messageId, onTap: _onTap);
    return rv;
  }
/*
  Colors getColor(User user) {
    if(lastColorIndex == -1) {
      lastColor
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
              stream: this.chatStream.value,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) {
                        Map<String, dynamic> chatDocument = snapshot.data.documents[index].data;
                        Chat chat = Chat.fromMap(chatDocument);
                        return buildItem(snapshot.data.documents[index].data['id'], chat, null, context);
                    },
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}

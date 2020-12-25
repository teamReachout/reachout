import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/constants.dart';
import 'package:reachout/models/users.dart';

class ChatApp extends StatefulWidget {
  final User sender;
  final User receiver;

  String recepient;

  ChatApp({this.receiver, this.sender});
  @override
  _ChatAppState createState() => _ChatAppState();

  String recepientName() {
    recepient =
        receiver.firstName.toString() + ' ' + receiver.lastName.toString();
    return recepient;
  }
}

class _ChatAppState extends State<ChatApp> {
  String textMessage;

  final textEditingControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.receiver.firstName);
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.recepientName();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(name),
        backgroundColor: Color(0xFF393e46),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: messagesRef
                    .document(widget.receiver.id)
                    .collection('userChats')
                    .document(widget.sender.id)
                    .collection('userMessages')
                    .orderBy(
                      'time',
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData != true) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data.documents.reversed;
                  List<MessageBubble> textWidgets = [];
                  for (var message in messages) {
                    final messageText = message.data['text'];
                    final messageSender = message.data['sender'];
                    final messageTime = message.data['time'] as Timestamp;
                    final whoSent = currentUser.id;

                    final messageWidget = MessageBubble(
                      messageSender: messageSender,
                      messageText: messageText,
                      isMe: whoSent == messageSender,
                      time: messageTime,
                    );
                    textWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: ListView(
                        reverse: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        children: textWidgets),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingControl,
                      onChanged: (value) {
                        textMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textEditingControl.clear();
                      messagesRef
                          .document(widget.sender.id)
                          .collection('userChats')
                          .document(widget.receiver.id)
                          .collection('userMessages')
                          .add({
                        'sender': widget.sender.id,
                        'text': textMessage,
                        'receiver': widget.receiver.id,
                        'time': FieldValue.serverTimestamp(),
                      });
                      messagesRef
                          .document(widget.receiver.id)
                          .collection('userChats')
                          .document(widget.sender.id)
                          .collection('userMessages')
                          .add({
                        'sender': widget.sender.id,
                        'text': textMessage,
                        'receiver': widget.receiver.id,
                        'time': FieldValue.serverTimestamp(),
                      });
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

class MessageBubble extends StatelessWidget {
  final String messageText;
  final String messageSender;
  final bool isMe;
  final Timestamp time;

  MessageBubble({this.messageText, this.messageSender, this.isMe, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '',
            style: TextStyle(
              fontSize: 11.0,
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Material(
              color: isMe ? Color(0xFF880E4F) : Colors.grey[200],
              elevation: 5.0,
              borderRadius: isMe
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    )
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  '$messageText',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

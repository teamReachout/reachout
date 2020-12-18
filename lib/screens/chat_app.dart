import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';

class ChatApp extends StatefulWidget {
  final User sender;
  final User reciever;

  ChatApp({
    this.sender,
    this.reciever,
  });
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  // final ChatUser user1 = ChatUser(
  //   name: "Fayeed",
  //   firstName: "Fayeed",
  //   lastName: "Pawaskar",
  //   uid: "12345678",
  //   avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  // );

  final ChatUser user = ChatUser(
    name: currentUser.firstName,
    firstName: currentUser.firstName,
    lastName: currentUser.lastName,
    uid: currentUser.id,
    avatar: currentUser.photoUrl,
  );

  // final ChatUser otherUser = ChatUser(
  //   name: "Mrfatty",
  //   uid: "25649654",
  // );

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();
  List<DocumentSnapshot> items = [];
  var i = 0;

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) async {
    // print(message.toJson());
    // var documentReference = Firestore.instance
    //     .collection('messages')
    //     .document(DateTime.now().millisecondsSinceEpoch.toString());

    messagesRef
        .document(widget.sender.id)
        .collection('userChats')
        .document(widget.reciever.id)
        .setData(message.toJson());

    // await Firestore.instance.runTransaction((transaction) async {
    //   await transaction.set(
    //     documentReference,
    //     message.toJson(),
    //   );
    // });
    /* setState(() {
      messages = [...messages, message];
      print(messages.length);
    });

    if (i == 0) {
      systemMessage();
      Timer(Duration(milliseconds: 600), () {
        systemMessage();
      });
    } else {
      systemMessage();
    } */
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  getMessages() async {
    DocumentSnapshot doc = await messagesRef
        .document(widget.sender.id)
        .collection('userChats')
        .document(widget.reciever.id)
        .get();

    items.add(doc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
      ),
      body: StreamBuilder(
        // stream: Firestore.instance.collection('messages').snapshots(),
        stream: messagesRef
            .document(widget.sender.id)
            .collection('userChats')
            .document(widget.reciever.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          } else {
            items.add(snapshot.data);
            var messages =
                items.map((i) => ChatMessage.fromJson(i.data)).toList();
            return DashChat(
              key: _chatViewKey,
              inverted: false,
              onSend: onSend,
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              user: user,
              inputDecoration:
                  InputDecoration.collapsed(hintText: "Add message here..."),
              dateFormat: DateFormat('yyyy-MMM-dd'),
              timeFormat: DateFormat('HH:mm'),
              messages: messages,
              showUserAvatar: false,
              showAvatarForEveryMessage: false,
              scrollToBottom: true,
              onPressAvatar: (ChatUser user) {
                // print("OnPressAvatar: ${user.name}");
              },
              onLongPressAvatar: (ChatUser user) {
                // print("OnLongPressAvatar: ${user.name}");
              },
              inputMaxLines: 5,
              messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              alwaysShowSend: true,
              inputTextStyle: TextStyle(fontSize: 16.0),
              inputContainerStyle: BoxDecoration(
                border: Border.all(width: 0.0),
                color: Colors.white,
              ),
              onQuickReply: (Reply reply) {
                setState(() {
                  messages.add(
                    ChatMessage(
                      text: reply.value,
                      createdAt: DateTime.now(),
                      user: user,
                    ),
                  );

                  messages = [...messages];
                });

                Timer(Duration(milliseconds: 300), () {
                  _chatViewKey.currentState.scrollController
                    ..animateTo(
                      _chatViewKey.currentState.scrollController.position
                          .maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );

                  if (i == 0) {
                    systemMessage();
                    Timer(Duration(milliseconds: 600), () {
                      systemMessage();
                    });
                  } else {
                    systemMessage();
                  }
                });
              },
              onLoadEarlier: () {
                // print("laoding...");
              },
              shouldShowLoadEarlier: false,
              showTraillingBeforeSend: true,
              trailing: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () async {
                    File result = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                      maxHeight: 400,
                      maxWidth: 400,
                    );

                    if (result != null) {
                      final StorageReference storageRef =
                          FirebaseStorage.instance.ref().child("chat_images");

                      StorageUploadTask uploadTask = storageRef.putFile(
                        result,
                        StorageMetadata(
                          contentType: 'image/jpg',
                        ),
                      );
                      StorageTaskSnapshot download =
                          await uploadTask.onComplete;

                      String url = await download.ref.getDownloadURL();

                      ChatMessage message =
                          ChatMessage(text: "", user: user, image: url);

                      var documentReference = Firestore.instance
                          .collection('messages')
                          .document(
                              DateTime.now().millisecondsSinceEpoch.toString());

                      Firestore.instance.runTransaction((transaction) async {
                        await transaction.set(
                          documentReference,
                          message.toJson(),
                        );
                      });
                    }
                  },
                )
              ],
            );
          }
        },
      ),
    );
  }
}

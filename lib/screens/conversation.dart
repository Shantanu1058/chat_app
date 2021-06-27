import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/models/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;

  ConversationScreen({this.chatRoomId, this.userName});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Stream<QuerySnapshot> chatMessageStream;
  @override
  void initState() {
    DataBase().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.requireData.size,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.requireData.docs[index].get("message"),
                    sendByMe: Constants.name ==
                        snapshot.requireData.docs[index].get("sendBy"),
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.name,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      setState(() {
        messageEditingController.text = "";
        DataBase().addMessage(widget.chatRoomId, chatMessageMap);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.userName),
        ),
        body: Stack(children: [
          chatMessages(),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 8),
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.85,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                          cursorHeight: 23.0,
                          controller: messageEditingController,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintText: "Type The Message",
                              border: InputBorder.none)),
                    ),
                  ]),
                ),
                GestureDetector(
                    onTap: () {
                      addMessage();
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 8, 0),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.1,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.red),
                        child: Icon(Icons.send)))
              ],
            ),
          ),
        ]));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            color: sendByMe ? Colors.yellow : Colors.green),
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(),
        ),
      ),
    );
  }
}

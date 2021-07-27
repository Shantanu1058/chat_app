import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/helpers/helpersfunctions.dart';
import 'package:chat_app/models/auth.dart';
import 'package:chat_app/models/database.dart';
import 'package:chat_app/screens/conversation.dart';
import 'package:chat_app/screens/search.dart';
import 'package:chat_app/screens/settings.dart';
import 'package:chat_app/widget/authenticate.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  static const routeName = '/chat-room';
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  DataBase dataBase = DataBase();
  Stream chatRoomsStream;
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.requireData.size,
                itemBuilder: (context, index) {
                  return ChatTile(
                      snapshot.requireData.docs[index]
                          .get("chatRoomId")
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.name, ""),
                      snapshot.requireData.docs[index]
                          .get("chatRoomId")
                          .toString());
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.name = await HelperFunctions.getUserName();
    dataBase.getUserChats(Constants.name).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(SearchScreen.routeName),
              child: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(Icons.search)),
            ),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(SettingScreen.routeName);
                        // Navigator.pop(super.context, 1);
                      },
                      child: Text("Settings")),
                  value: 1,
                ),
                PopupMenuItem(
                  child: GestureDetector(
                      onTap: () async {
                        await AuthMethods().signOut().then(
                            (value) => HelperFunctions.saveUserLoggedIn(false));
                        Navigator.pushReplacementNamed(
                            context, Authenticate.routeName);
                      },
                      child: Text("Logout")),
                  value: 2,
                )
              ],
            ),
          ],
          title: Text("ChatRoom"),
        ),
        body: chatRoomList());
  }
}

class ChatTile extends StatelessWidget {
  final String userName;
  final String chatRoom;
  ChatTile(this.userName, this.chatRoom);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(
                userName: userName,
                chatRoomId: chatRoom,
              ),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, style: BorderStyle.solid)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                    ),
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(40)),
                child: Text('${userName.substring(0, 1).toUpperCase()}',
                    style: TextStyle(fontSize: 16.0))),
            SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}

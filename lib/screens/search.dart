import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/models/database.dart';
import 'package:chat_app/screens/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DataBase dataBaseMethods = DataBase();
  TextEditingController search = TextEditingController();
  QuerySnapshot searchSnapshot;
  initSearch() {
    dataBaseMethods.getUserByUserName(search.text).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.docs[index].get("name"),
                email: searchSnapshot.docs[index].get("email"),
              );
            },
          )
        : Container();
  }

  Widget searchTile({String userName, String email}) {
    return GestureDetector(
      onTap: () {
        createChatRoom(userName);
      },
      child: Container(
        child: ListTile(
          title: Text(userName),
          subtitle: Text(email),
        ),
      ),
    );
  }

  createChatRoom(String userName) {
    if (userName != Constants.name) {
      List<String> users = [userName, Constants.name];
      String chatRoomId = getChatRoomId(userName, Constants.name);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatRoomId: chatRoomId,
              userName: search.text,
            ),
          ));
    } else {
      SnackBar(content: Text("Cannot Search Your Own Name "));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: search,
                          decoration: InputDecoration(
                              hintText: "Search...",
                              border: InputBorder.none))),
                  GestureDetector(
                      onTap: () {
                        initSearch();
                      },
                      child: Icon(Icons.search))
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}

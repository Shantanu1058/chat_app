import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/helpers/helpersfunctions.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/settings';
  @override
  Widget build(BuildContext context) {
    Constants.name = HelperFunctions.getUserName().toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 25, 10, 15),
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
                      borderRadius: BorderRadius.circular(50)),
                  child: Text("${Constants.name.substring(0, 1)}",
                      style: TextStyle(fontSize: 16.0))),
              SizedBox(
                width: 10,
              ),
              Text(
                Constants.name,
                softWrap: true,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        Divider(
          thickness: 2,
        ),
        ListTile(
          onTap: () {},
          subtitle: Text("Theme, wallpapers, chat history"),
          leading: Icon(
            Icons.chat_sharp,
            color: Colors.blue,
          ),
          title: Text("Chats"),
        ),
        Divider(),
        ListTile(
          onTap: () {},
          subtitle: Text("Privacy, security"),
          leading: Icon(
            Icons.vpn_key,
            color: Colors.blue,
          ),
          title: Text(
            "Account",
          ),
        ),
        Divider(),
      ]),
    );
  }
}

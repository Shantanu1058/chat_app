import 'package:chat_app/helpers/helpersfunctions.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/search.dart';
import 'package:chat_app/screens/settings.dart';
import 'package:chat_app/widget/authenticate.dart';
import 'package:chat_app/widget/forget_password.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLogIn = false;
  getUserLogInState() async {
    return await HelperFunctions.getUserLoggedIn().then((value) {
      setState(() {
        isUserLogIn = value;
      });
    });
  }

  @override
  void initState() {
    getUserLogInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M4RS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isUserLogIn != null
          ? isUserLogIn
              ? ChatRoomScreen()
              : Authenticate()
          : Authenticate(),
      routes: {
        ChatRoomScreen.routeName: (context) => ChatRoomScreen(),
        SearchScreen.routeName: (context) => SearchScreen(),
        ForgetPassword.routeName: (context) => ForgetPassword(),
        SettingScreen.routeName: (context) => SettingScreen()
      },
    );
  }
}

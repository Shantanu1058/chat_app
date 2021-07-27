import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/helpers/helpersfunctions.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/search.dart';
import 'package:chat_app/screens/settings.dart';
import 'package:chat_app/widget/authenticate.dart';
import 'package:chat_app/widget/forget_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);
FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
    new FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await flutterLocalNotificationPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getInitialMessage();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;
  String token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    Constants.name = await HelperFunctions.getUserName();
    var users = Map<String, dynamic>();
    users[Constants.name.toString()] = token;
    FirebaseFirestore.instance.collection('devices').doc(token).set(users);
  }

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
    var initilisation = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initialisationSettings = InitializationSettings(android: initilisation);
    flutterLocalNotificationPlugin.initialize(initialisationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });
    getToken();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   getToken();
  //   print("executed");
  //   super.didChangeDependencies();
  // }

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
        SettingScreen.routeName: (context) => SettingScreen(),
        Authenticate.routeName: (context) => Authenticate()
      },
    );
  }
}

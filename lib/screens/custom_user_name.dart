import 'dart:io';

import 'package:chat_app/helpers/helpersfunctions.dart';
import 'package:chat_app/models/auth.dart';
import 'package:chat_app/models/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CustomUserName extends StatefulWidget {
  const CustomUserName({Key key}) : super(key: key);

  @override
  _CustomUserNameState createState() => _CustomUserNameState();
}

class _CustomUserNameState extends State<CustomUserName> {
  TextEditingController controller = new TextEditingController();
  QuerySnapshot snapshot;
  AuthMethods auth = new AuthMethods();
  DataBase dataBase = DataBase();
  String email;
  File imageFile;
  getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(pickedFile.path);
    });
    String fileName = basename(imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('userProfilePhoto/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  saveUserName() async {
    if (controller != null || controller.text.isNotEmpty) {
      // auth.signInWithGoogle().then((value) {
      //   email = value['email'];
      // });
      // dataBase.getUserByUserEmail(email).then((val) {
      //   snapshot = val;
      //   snapshot.docs[0].data();
      // });
      await HelperFunctions.saveUserName(controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Your Custom UserName"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                      margin: EdgeInsets.fromLTRB(100, 200, 140, 50),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(200)),
                      child: Text("Tap Here To Choose Your Profile Photo")),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: "Add Your UserName"),
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    getImage();
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 8, 0),
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Center(child: Text("Save"))))
            ],
          ),
        ),
      ),
    );
  }
}

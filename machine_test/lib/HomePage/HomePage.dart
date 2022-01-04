import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/HomePage/HomePageController.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = FirebaseAuth.instance.currentUser;
  HomePageController homePageController = HomePageController();

  @override
  void initState() {
      super.initState();
     homePageController.storeFirebaseToken(user);
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(user.uid),
          Text(user.email),
          Text(user.displayName),
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
            radius: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Icon(Icons.exit_to_app),
          )
        ],
      )),
    );
  }
}

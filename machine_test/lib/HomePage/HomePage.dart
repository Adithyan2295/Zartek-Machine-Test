import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/HomePage/HomePageController.dart';
import 'package:machine_test/HomePage/HomePageModel.dart';
import 'package:machine_test/Model/SingleTonModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController homePageController = HomePageController();
  HomePageModel homePageModel = HomePageModel();

  @override
  void initState() {
    super.initState();
    homePageController.storeFirebaseToken(homePageModel.user);
    homePageController.fetchAPIData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      drawer: drawer(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(homePageModel.user.uid),
          Text(homePageModel.user.email),
          Text(homePageModel.user.displayName),
          CircleAvatar(
            backgroundImage: NetworkImage(homePageModel.user.photoURL),
            radius: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              // FirebaseAuth.instance.signOut();
              // homePageController.removeFirebaseToken(context);
              print(Singleton.singleton.menuModel[0].tableMenuList[0].menuCategory);
            },
            child: Icon(Icons.exit_to_app),
          )
        ],
      )),
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[drawerHeader(), logoutButton()],
      ),
    );
  }

  Widget logoutButton() {
    return ListTile(
      onTap: () {
        FirebaseAuth.instance.signOut();
        homePageController.removeFirebaseToken(context);
      },
      title: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          children: [
            Icon(
              Icons.exit_to_app,
              color: Colors.grey,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Log out",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget drawerHeader() {
    return DrawerHeader(
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(homePageModel.user.photoURL),
            radius: 20,
          ),
          Text(homePageModel.user.displayName),
          Text("${homePageModel.user.uid}"),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.green,
      ),
    );
  }
}

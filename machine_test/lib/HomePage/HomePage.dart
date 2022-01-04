import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/HomePage/HomePageController.dart';
import 'package:machine_test/HomePage/HomePageModel.dart';
import 'package:machine_test/Model/SingleTonModel.dart';
import 'package:badges/badges.dart';


HomePageState globalHomepageState;
class HomePage extends StatefulWidget {
  @override
  HomePageState createState(){
    globalHomepageState = HomePageState();
    return globalHomepageState;
  }
}

class HomePageState extends State<HomePage> {
  
  HomePageController homePageController = HomePageController();
  HomePageModel homePageModel = HomePageModel();

  @override
  void initState() {
    super.initState();
    homePageController.storeFirebaseToken(homePageModel.user);
    homePageController.fetchAPIData();
  }

  callSetState() {
    setState(() { });
  }
  @override
  Widget build(BuildContext context) {
    return mainWidget();
  }

  Widget mainWidget() {
    return Stack(
      children: [
        Singleton.singleton.menuModel != null?
        DefaultTabController(
          length: Singleton.singleton.menuModel[0].tableMenuList.length,
          child: Scaffold(
            appBar: appbar(),
            drawer: drawer(),
            body: body(),
          ),
        ):
        Positioned.fill(child: loadingIndicator())
      ],
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

  appbar() {
    return AppBar(
      title: Text('Home'),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.grey),
      actions: [
        cartIcon(),
        SizedBox(
          width: 10,
        ),
      ],
      bottom: tabBar(),
    );
  }

  Widget tabBar() {
    return TabBar(
        isScrollable: true,
        indicatorColor: Colors.red,
        labelStyle: TextStyle(fontSize: 12, color: Colors.red),
        labelColor: Colors.red,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(fontSize: 12, color: Colors.grey),
        tabs: tabbarList());
  }

  List<Widget> tabbarList() {
    var temp = Singleton.singleton.menuModel[0].tableMenuList;
    List<Widget> tab = [];
    for (var tempMenutype in temp) {
      tab.add(Tab(
        text: tempMenutype.menuCategory,
      ));
    }
    return tab;
  }

  Widget cartIcon() {
    return Center(
      child: Badge(
        position: BadgePosition.topEnd(top: 0, end: 2),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(
          '7',
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
      ),
    );
  }

  body() {
    return Stack(
      children: [
        Center(
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
                print(Singleton
                    .singleton.menuModel[0].tableMenuList[0].menuCategory);
              },
              child: Icon(Icons.exit_to_app),
            )
          ],
        )),
        // Positioned.fill(child: loadingIndicator())
      ],
    );
  }

  loadingIndicator() {
    return Visibility(
      visible: Singleton.singleton.isLoading,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
          child:
              Container(color: Colors.white, child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/Checkout/CheckoutPage.dart';
import 'package:machine_test/HomePage/HomePageController.dart';
import 'package:machine_test/HomePage/HomePageModel.dart';
import 'package:machine_test/Model/CheckoutListModel.dart';
import 'package:machine_test/Model/MenuModel.dart';
import 'package:machine_test/Model/SingleTonModel.dart';
import 'package:badges/badges.dart';

HomePageState globalHomepageState;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget();
  }

  Widget mainWidget() {
    return Stack(
      children: [
        Singleton.singleton.menuModel != null
            ? DefaultTabController(
                length: Singleton.singleton.menuModel[0].tableMenuList.length,
                child: Scaffold(
                  appBar: appbar(),
                  drawer: drawer(),
                  body: body(),
                ),
              )
            : Positioned.fill(child: loadingIndicator())
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
          Singleton.singleton.cartCount.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckoutPage(),
                          fullscreenDialog: true))
                  .then((value) {
                setState(() {});
              });
            }),
      ),
    );
  }

  body() {
    return TabBarView(children: tabbarView());
  }

  loadingIndicator() {
    return Visibility(
      visible: Singleton.singleton.isLoading,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
          child: Container(
              color: Colors.white, child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  List<Widget> tabbarView() {
    var temp = Singleton.singleton.menuModel[0].tableMenuList;
    List<Widget> tab = [];
    temp.asMap().forEach((mainIndex, tempMenutype) {
      tab.add(ListView.builder(
          itemBuilder: (context, index) {
            return viewCardType(tempMenutype, index, mainIndex);
          },
          itemCount: tempMenutype.categoryDishes.length));
    });
    return tab;
  }

  viewCardType(TableMenuList tempMenutype, int index, int mainIndex) {
    return Container(
      color: Colors.grey.withOpacity(0.5),
      padding: EdgeInsets.only(bottom: 1),
      child: Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topContainer(tempMenutype, index, mainIndex),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  tempMenutype.categoryDishes[index].dishDescription,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )),
            SizedBox(
              height: 10,
            ),
            buttonWidget(tempMenutype, index, mainIndex),
            Visibility(
              visible: tempMenutype.categoryDishes[index].addonCat.isNotEmpty,
              child: Container(
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text("Customizations Available ",
                      style: TextStyle(fontSize: 12, color: Colors.red))),
            ),
          ],
        ),
      ),
    );
  }

  topContainer(TableMenuList tempMenutype, int index, int mainIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  tempMenutype.categoryDishes[index].dishName,
                  overflow: TextOverflow.clip,
                )),
            Container(
                padding: EdgeInsets.only(left: 10),
                child:
                    Text("₹ ${tempMenutype.categoryDishes[index].dishPrice}")),
          ],
        ),
        Container(
            padding: EdgeInsets.only(top: 30),
            child: Text(
                "${tempMenutype.categoryDishes[index].dishCalories.toInt()} calories "
                    .toString())),
        Container(
          height: MediaQuery.of(context).size.height / 10.8,
          width: MediaQuery.of(context).size.width / 5.1,
          margin: EdgeInsets.only(right: 10),
          child: Image.asset('assets/food.png'),
        ),
      ],
    );
  }

  buttonWidget(TableMenuList tempMenutype, int index, int mainIndex) {
    return Container(
        margin: EdgeInsets.only(
          left: 10,
        ),
        width: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.green,
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            addAndMinus(false, tempMenutype, index, mainIndex),
            Text(tempMenutype.categoryDishes[index].dishOrdeCount.toString(),
                style: TextStyle(fontSize: 16, color: Colors.white)),
            addAndMinus(true, tempMenutype, index, mainIndex),
          ],
        ));
  }

  Widget addAndMinus(
      isAdd, TableMenuList tempMenutype, int index, int mainIndex) {
    return GestureDetector(
      onTap: (tempMenutype.categoryDishes[index].dishOrdeCount == 0 && !isAdd)
          ? null
          : () {
              isAdd
                  ? tempMenutype.categoryDishes[index].dishOrdeCount++
                  : tempMenutype.categoryDishes[index].dishOrdeCount--;
              isAdd
                  ? Singleton.singleton.cartCount++
                  : Singleton.singleton.cartCount--;
              CheckoutListModel checkoutListModel = CheckoutListModel();
              if (isAdd) {
                checkoutListModel.mainIndex = mainIndex;
                checkoutListModel.index = index;
                checkoutListModel.tableMenuList = tempMenutype;
                Singleton.singleton
                        .cartData[tempMenutype.categoryDishes[index].dishId] =
                    tempMenutype.categoryDishes[index];
              } else if (tempMenutype.categoryDishes[index].dishOrdeCount ==
                  0) {
                Singleton.singleton.cartData
                    .remove(tempMenutype.categoryDishes[index].dishId);
              } else {
                checkoutListModel.mainIndex = mainIndex;
                checkoutListModel.index = index;
                checkoutListModel.tableMenuList = tempMenutype;
                Singleton.singleton
                        .cartData[tempMenutype.categoryDishes[index].dishId] =
                    tempMenutype.categoryDishes[index];
              }

              setState(() {});
            },
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 12,
        child: Image.asset(
          isAdd ? "assets/add.png" : "assets/minus.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:machine_test/Model/SingleTonModel.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: body(),
    );
  }

  body() {
    return Container(
      child: Column(
        children: menuList(),
      ),
    );
  }

  appbar() {
    return AppBar(
      title: Text(
        'Order Summary',
        style: TextStyle(color: Colors.grey),
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey),
        onPressed: () => Navigator.of(context).pop(),
      ),
      iconTheme: IconThemeData(
        color: Colors.grey,
      ),
    );
  }

  Widget addAndMinus(isAdd, String tempMenutype) {
    return GestureDetector(
      onTap: () {
        isAdd
            ? Singleton.singleton.cartData[tempMenutype].dishOrdeCount++
            : Singleton.singleton.cartData[tempMenutype].dishOrdeCount--;
        isAdd
            ? Singleton.singleton.cartCount++
            : Singleton.singleton.cartCount--;
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

  buttonWidget(
    String tempMenutype,
  ) {
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
            addAndMinus(
              false,
              tempMenutype,
            ),
            Text(
                Singleton.singleton.cartData[tempMenutype].dishOrdeCount
                    .toString(),
                style: TextStyle(fontSize: 16, color: Colors.white)),
            addAndMinus(
              true,
              tempMenutype,
            ),
          ],
        ));
  }

  List<Widget> menuList() {
    var temp = Singleton.singleton.cartData.keys;
    List<Widget> tab = [];
    for (var tempMenutype in temp) {
      tab.add(
        Column(
          children: [
            Container(
              child: Text(Singleton.singleton.cartData[tempMenutype].dishName),
            ),
            buttonWidget(tempMenutype)
          ],
        ),
      );
    }
    return tab;
  }
}

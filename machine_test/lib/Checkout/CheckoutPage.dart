import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:machine_test/Checkout/CheckoutController.dart';
import 'package:machine_test/Checkout/CheckoutModel.dart';
import 'package:machine_test/Model/SingleTonModel.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CheckoutController _checkoutController = CheckoutController();
  CheckoutModel _checkoutModel = CheckoutModel();
  @override
  void initState() {
    super.initState();
    _checkoutModel.totalPrice = _checkoutController.calculateTotalAmount();
  }

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
        isAdd
            ? _checkoutModel.totalPrice +=
                Singleton.singleton.cartData[tempMenutype].dishPrice
            : _checkoutModel.totalPrice -=
                Singleton.singleton.cartData[tempMenutype].dishPrice;
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
        width: MediaQuery.of(context).size.width / 3.5,
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
    tab.add(topHeading());
    for (var tempMenutype in temp) {
      tab.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    Singleton.singleton.cartData[tempMenutype].dishName,
                    overflow: TextOverflow.clip,
                  ),
                ),
                buttonWidget(tempMenutype),
                Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                        "₹ ${Singleton.singleton.cartData[tempMenutype].dishPrice * Singleton.singleton.cartData[tempMenutype].dishOrdeCount}")),
              ],
            ),
            Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                    "₹ ${Singleton.singleton.cartData[tempMenutype].dishPrice}")),
            Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                    "${Singleton.singleton.cartData[tempMenutype].dishCalories.toInt()} calories")),
          ],
        ),
      );
    }
    tab.add(totalAmount());
    return tab;
  }

  topHeading() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.green,
      ),
      child: Center(
        child: Text(
            '${Singleton.singleton.cartData.length} Dishes - ${Singleton.singleton.cartCount} Items',
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  totalAmount() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.green,
      ),
      child: Center(
        child: Text('Total Amount : ${_checkoutModel.totalPrice}',
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}

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
    return Stack(
      children: [
        Positioned.fill(
          child: scrollList(),
        ),
        Positioned(bottom: 10, child: loginButtonView())
      ],
    );
  }

  scrollList() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 60),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: menuList(),
        ),
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
      child: Icon(
        isAdd ? Icons.add : Icons.remove,
        color: Colors.white,
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
          borderRadius: BorderRadius.circular(12),
          color: Colors.green.shade800,
        ),
        height: 30,
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
        cardContent(tempMenutype),
      );
    }
    tab.add(totalAmount());
    return tab;
  }

  topHeading() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.green.shade800,
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
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 10,
            ),
            child: Text('Total Amount',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Text(
              '\₹ ${_checkoutModel.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardContent(String tempMenutype) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width / 3,
              child: Text(
                Singleton.singleton.cartData[tempMenutype].dishName,
                overflow: TextOverflow.clip,
              ),
            ),
            buttonWidget(tempMenutype),
            Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                    "₹ ${Singleton.singleton.cartData[tempMenutype].dishPrice * Singleton.singleton.cartData[tempMenutype].dishOrdeCount}")),
          ],
        ),
        Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 10),
            child: Text(
                "₹ ${Singleton.singleton.cartData[tempMenutype].dishPrice}")),
        Container(
            margin: EdgeInsets.only(bottom: 30),
            padding: EdgeInsets.only(left: 10),
            child: Text(
                "${Singleton.singleton.cartData[tempMenutype].dishCalories.toInt()} calories")),
        Container(
          margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.withOpacity(0.4),
        )
      ],
    );
  }

  loginButtonView() {
    return GestureDetector(
      onTap: () {
        showDialogue();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.green.shade800,
        ),
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: MediaQuery.of(context).size.width - 40,
        height: 45,
        child: Center(
          child: Text('Place Order',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
        ),
      ),
    );
  }

  showDialogue() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Order Placed'),
            content: Text('Your order has been placed successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _checkoutController.resetCount();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}

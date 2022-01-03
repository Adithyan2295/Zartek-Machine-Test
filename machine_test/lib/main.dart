import 'package:flutter/material.dart';
import 'package:machine_test/Login/LoginPage.dart';

void main() {
  runApp(MockAPP());
}

class MockAPP extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mocky',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}



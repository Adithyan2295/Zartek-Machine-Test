import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:machine_test/HomePage/HomePage.dart';
import 'package:machine_test/Login/LoginPage.dart';
import 'package:machine_test/Model/SingleTonModel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   bool isLoggedIn =  await checkIfLoggedIn();
   await Firebase.initializeApp();
  runApp(MockAPP(isLoggedIn));
}
    //Check if user is logged in
  checkIfLoggedIn() async{
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'userToken');
    if(token != null){
      Singleton.singleton.userToken = token;
      return true;
    }
    return false;
  }

class MockAPP extends StatelessWidget {
   final bool loggedIn;
  MockAPP(this.loggedIn);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mocky',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:this.loggedIn ? HomePage() : LoginPage(),
    );
  }
}



import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/HomePage/HomePage.dart';
import 'package:machine_test/Model/MenuModel.dart';
import 'package:machine_test/Model/SingleTonModel.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePageController extends ControllerMVC {
  //Add token to secure storage to keep logged in
  storeFirebaseToken(User user) async {
    var tokenRegistered = await user.getIdToken();
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'userToken', value: tokenRegistered);
    Singleton.singleton.userToken = tokenRegistered;
  }

  //Remove token from secure storage to logout
  removeFirebaseToken(BuildContext context) async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'userToken');
    Singleton.singleton.userToken = null;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<dynamic> getDataFunction() async {
    var url = 'https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad';
    print(url);
    var response;
    try {
      response = await http.get(
        Uri.parse(url),
      );
    } on SocketException catch (_) {
      response = false;
    }
    return response;
  }
  //Fetch Api Data

  fetchAPIData() async {
    Singleton.singleton.isLoading = true;
    Singleton.singleton.menuModel = null;
     Singleton.singleton.cartCount = 0;
    globalHomepageState.callSetState();
    var getData = await getDataFunction();
    if (getData != false) {
      Singleton.singleton.apiData = getData.body;
      Singleton.singleton.menuModel = menuModelFromJson(getData.body);
      Singleton.singleton.isLoading = false;
      globalHomepageState.callSetState();
    } else {
      Singleton.singleton.isLoading = false;
      globalHomepageState.callSetState();
    }
  }
}

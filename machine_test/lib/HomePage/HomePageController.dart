import 'package:firebase_auth/firebase_auth.dart';
import 'package:machine_test/Model/SingleTonModel.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePageController extends ControllerMVC {
  //Add token to secure storage to keep logged in
  storeFirebaseToken(User user) async{
    var  tokenRegistered = await user.getIdToken();
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'userToken', value: tokenRegistered);
    Singleton.singleton.userToken = tokenRegistered;
  }

  //Remove token from secure storage to logout
  removeFirebaseToken() async{
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'userToken');
    Singleton.singleton.userToken = null;
  }

}
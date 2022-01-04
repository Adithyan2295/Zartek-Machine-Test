import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/Firebase/Authentication.dart';
import 'package:machine_test/HomePage/HomePage.dart';
import 'package:machine_test/Login/LoginModel.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class LoginController extends ControllerMVC {
//Google Button click action
  googleButtonAction(BuildContext context) async {
    print('google button clicked');
    FirebaseService service = new FirebaseService();
    try {
      await service.signInwithGoogle();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        print(e.message);
      }
    }
    print(LoginModel().test);
  }

// phone Button click action
  phoneButtonAction() {
    print('phone button clicked');
    print(LoginModel().test + 1);
  }
}

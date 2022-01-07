import 'package:flutter/material.dart';
import 'package:machine_test/Login/LoginController.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginController _loginController = LoginController();

  //Login page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            firebaseLogo(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
        //Two Button for Login
            loginButton(true),
            SizedBox(height: 20),
            loginButton(false),
          ],
        ),
      ),
    );
  }

  Widget firebaseLogo() {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Image.asset('assets/firebaseLogo.png'));
  }

  Widget loginButton(bool isGoogle) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: isGoogle ? Colors.blue : Colors.red,
          primary: isGoogle ? Colors.blue : Colors.green,
          padding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async{
          isGoogle
              ? _loginController.googleButtonAction(context)
              : await _loginController.phoneButtonAction(context);
        },
        child: loginButtonView(isGoogle));
  }

  loginButtonView(bool isGoogle) {
    return Container(
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
              maxRadius: 15,
              backgroundColor: Colors.white,
              child: Image.asset(
                  isGoogle ? 'assets/googleLogo.png' : 'assets/phone.png',
                  height: 20.0)),
          Expanded(
            child: Container(
              child: Center(
                child: Text(isGoogle ? 'Google' : 'Phone',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:machine_test/Firebase/Authentication.dart';
import 'package:machine_test/HomePage/HomePage.dart';
import 'package:machine_test/Model/SingleTonModel.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  bool noOtpYet = true;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(), body: body());
  }

  appbar() {
    return AppBar(
      title: Text(
        'Verify Phone Number',
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

  Widget body() {
    return Column(
      children: [
        phoneNumber(),
        otp(),
        SizedBox(height: 20),
        floatingActionButton()
      ],
    );
  }

  phoneNumber() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: TextField(
        controller: phoneNumberController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          hintText: 'Phone Number',
          hintStyle: TextStyle(color: Colors.grey),
          prefixText: '+91',
          prefixStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  otp() {
    return Visibility(
      visible: !noOtpYet,
      child: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: TextField(
            controller: otpController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              hintText: 'OTP',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )),
    );
  }

  floatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        otpButtonPressed();
      },
      child: Icon(Icons.login),
      backgroundColor: Colors.blue,
    );
  }

  void otpButtonPressed() async {
    if (noOtpYet) {
      setState(() {
        noOtpYet = false;
      });
      if (phoneNumberController.text.length == 10) {
        noOtpYet = false;
        FirebaseService service = new FirebaseService();
        String phoneNumber = '+91' + phoneNumberController.text;
        try {
          await service.registerUser(phoneNumber);
        } catch (e) {
          if (e is FirebaseAuthException) {
            print(e.message);
          }
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Invalid Phone Number'),
                content: Text('Please enter a valid phone number'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } else {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: Singleton.singleton.verificationId,
          smsCode: otpController.text);
      Singleton.singleton.credential = credential;
      FirebaseService service = new FirebaseService();
      await service.verificationCompleted(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }
}

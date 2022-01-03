import 'package:machine_test/Login/LoginModel.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class LoginController extends ControllerMVC {

//Google Button click action
  googleButtonAction() {
    print('google button clicked');
    print(LoginModel().test);
  }

// phone Button click action
  phoneButtonAction() {
    print('phone button clicked');
    print(LoginModel().test+1);
  }
  
}
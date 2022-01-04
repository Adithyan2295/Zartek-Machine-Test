import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HomePageModel extends ModelMVC {
  User user = FirebaseAuth.instance.currentUser;
}
  

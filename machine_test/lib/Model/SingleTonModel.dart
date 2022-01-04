import 'package:machine_test/Model/MenuModel.dart';

class Singleton {
  static final Singleton singleton = Singleton._internal();

  factory Singleton() {
    return singleton;
  }

  String userToken;
  bool isLoading = true;
  List<MenuModel> menuModel = [];
  var apiData;

  Singleton._internal();
}

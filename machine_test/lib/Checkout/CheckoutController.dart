import 'package:machine_test/Model/SingleTonModel.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CheckoutController extends ControllerMVC {
  calculateTotalAmount() {
    var totalPrice = 0.0;
    var temp = Singleton.singleton.cartData.keys;

    for (var tempMenutype in temp) {
      var tempMenu = Singleton.singleton.cartData[tempMenutype];
      totalPrice += tempMenu.dishPrice * tempMenu.dishOrdeCount;
    }
    return totalPrice;
  }

  resetCount() {
    var temp = Singleton.singleton.cartData.keys;
    for (var tempMenutype in temp) {
      var tempMenu = Singleton.singleton.cartData[tempMenutype];
      tempMenu.dishOrdeCount = 0;
    }
    Singleton.singleton.cartData.clear();
    Singleton.singleton.cartCount = 0;
  }
}

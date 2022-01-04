class Singleton {
  static final Singleton singleton = Singleton._internal();

  factory Singleton() {
    return singleton;
  }

  String userToken;

  Singleton._internal();
}

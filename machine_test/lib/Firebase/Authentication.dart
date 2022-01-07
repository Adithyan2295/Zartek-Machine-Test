import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machine_test/Model/SingleTonModel.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ignore: missing_return
  Future<String> signInwithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future registerUser(String mobile,) async {
    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: (FirebaseAuthException authException){
  print(authException.message);
},
        codeSent: codeSend,
        codeAutoRetrievalTimeout: null);
  }

  verificationCompleted(AuthCredential authCredential) async{
     await _auth.signInWithCredential(authCredential);
  }
  codeSend (String verificationId, [int forceResendingToken]){
    print(verificationId);
    Singleton.singleton.verificationId=verificationId;
  }
}

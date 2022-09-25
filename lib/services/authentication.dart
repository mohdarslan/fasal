import 'package:firebase_auth/firebase_auth.dart';

class Authentication {

  static Future<UserCredential?> signIn(
      {String? verificationCode,
      String? smsCode,
      required String phoneNumber}) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationCode!, smsCode: smsCode ?? smsCode!));
    } catch (e, st) {
      credential = null;
    }
    return credential;
  }
}

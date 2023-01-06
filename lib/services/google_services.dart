import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleInfo extends GetxController {
  RxString photoUrl = ''.obs;
  RxString email = ''.obs;
  RxString openid = ''.obs;
  RxString displayName = ''.obs;

  void setData(
      {String? photoUrl, String? email, String? openid, String? displayName}) {
    this.photoUrl.value = photoUrl ?? '';
    this.email.value = email ?? '';
    this.openid.value = openid ?? '';
    this.displayName.value = displayName ?? '';
  }
}

class GoogleServices {
  static String? clientId = Platform.isIOS
      ? '108486831143-1hrtn3h0t65m1abjup0ovt1mq0rj7m3e.apps.googleusercontent.com'
      : null;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: clientId,
    // scopes: ['email', 'openid', 'profile'],
  );

  static Future<GoogleSignInAccount?> login() async {
    return _googleSignIn.signIn();
  }

  static Future logout() async => _googleSignIn.disconnect();
}

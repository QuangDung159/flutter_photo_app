import 'dart:io';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

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

class GetxNotification extends GetxController {
  RxString fcmToken = ''.obs;

  void setData({String? fcmToken}) {
    this.fcmToken.value = fcmToken ?? '';
  }
}

class GoogleServices {
  static String? clientId = Platform.isIOS
      ? '108486831143-isjt7gtmd6mdtgmarbgt1k7ihf30ngq7.apps.googleusercontent.com'
      : null;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: clientId,
    // scopes: ['email', 'openid', 'profile'],
  );

  static Future<GoogleSignInAccount?> login() async {
    return _googleSignIn.signIn();
  }

  static Future pushNotification({
    required String title,
    required String body,
  }) async {
    GetxNotification notification = Get.find<GetxNotification>();
    String? fcmToken = notification.fcmToken.value;
    if (fcmToken == '') {
      throw Exception('FCM token required');
    }

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization':
          'key=AAAAGUJRrCc:APA91bEq5cva5ddIrGWR-P8Llg_AmfZWcr6MP84m8pXozJuR863sM7qZBf8fgwWNJImojxl73RZzaEOmHlU7Omrj9Es9QSjBNP0ZSILC22TGQ4Y6ORA-fJ3F1gpyzQkUHeN0k44l2KiW'
    };

    String json =
        '{"to" : "$fcmToken","notification" : {"body" : "$body","title": "$title"}}';

    final res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: json,
    );

    print('res: ${res.body}');
  }

  static Future logout() async => _googleSignIn.disconnect();
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_photo_app/firebase_options.dart';
import 'package:flutter_photo_app/screens/home_screen.dart';
import 'package:flutter_photo_app/services/google_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init firebase service
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // init local storage
  await GetStorage.init();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final fcmToken = await FirebaseMessaging.instance.getToken();

  print('fcmToken: $fcmToken');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final googleInfo = Get.put(GoogleInfo());

  void getAuthInfo() {
    String? photoUrl = GetStorage().read('PHOTO_URL');
    String? email = GetStorage().read('EMAIL');
    String? openid = GetStorage().read('OPENID');
    String? displayName = GetStorage().read('DISPLAY_NAME');

    if (photoUrl != null && photoUrl != '') {
      googleInfo.setData(
        displayName: displayName,
        photoUrl: photoUrl,
        email: email,
        openid: openid,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // get auth (google info) from local storage
    getAuthInfo();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );

    return GetMaterialApp(
      title: 'Photos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

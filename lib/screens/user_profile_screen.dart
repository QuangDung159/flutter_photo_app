// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_photo_app/common/constants.dart';
import 'package:flutter_photo_app/components/c_elevated_button.dart';
import 'package:flutter_photo_app/screens/components/main_app_bar.dart';
import 'package:flutter_photo_app/screens/home_screen.dart';
import 'package:flutter_photo_app/services/google_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({
    super.key,
    this.payload,
  });

  final GoogleInfo googleInfo = Get.find<GoogleInfo>();
  final String? payload;

  void onLogout() async {
    GetStorage().remove('PHOTO_URL');
    GetStorage().remove('EMAIL');
    GetStorage().remove('DISPLAY_NAME');
    GetStorage().remove('OPENID');

    googleInfo.setData(
      photoUrl: '',
      email: '',
      openid: '',
      displayName: '',
    );

    await GoogleServices.logout();

    Get.to(() => HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(contentAppBarHeight),
        child: MainAppBar(
          hasAvatar: false,
          hasBack: true,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Hero(
              tag: 'avatar',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(googleInfo.photoUrl.value),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: CElevatedButton(
                onPressed: () => onLogout(),
                height: 30,
                width: 120,
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

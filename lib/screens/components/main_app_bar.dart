// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_photo_app/common/constants.dart';
import 'package:flutter_photo_app/components/c_app_bar.dart';
import 'package:flutter_photo_app/components/c_elevated_button.dart';
import 'package:flutter_photo_app/screens/components/avatar.dart';
import 'package:flutter_photo_app/screens/user_profile_screen.dart';
import 'package:flutter_photo_app/services/google_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainAppBar extends StatelessWidget {
  final bool? hasBack;
  final bool? hasAvatar;
  final googleInfo = Get.put(GoogleInfo());

  // hasAvatar default true
  // hasBack default false
  MainAppBar({Key? key, this.hasBack, this.hasAvatar}) : super(key: key);

  Future<void> _handleSignIn() async {
    try {
      final res = await GoogleServices.login();
      if (res != null) {
        googleInfo.setData(
          photoUrl: res.photoUrl,
          email: res.email,
          displayName: res.displayName,
          openid: res.id,
        );

        GetStorage().write('PHOTO_URL', res.photoUrl);
        GetStorage().write('EMAIL', res.email);
        GetStorage().write('DISPLAY_NAME', res.displayName);
        GetStorage().write('OPENID', res.id);

        GoogleServices.pushNotification(
          title: 'Hi ${googleInfo.displayName}',
          body: 'Welcome to Summoner\'s Rift',
        );
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'app_bar',
          child: renderAppBar(context, false),
        ),
        renderAppBar(context, true)
      ],
    );
  }

  Widget renderAvatarByLoginInfo(bool hasHero) {
    // check no has google info
    if (googleInfo.photoUrl.value != '') {
      return hasHero
          ? Hero(
              tag: 'avatar',
              child: Avatar(googleInfo: googleInfo),
            )
          : Avatar(googleInfo: googleInfo);
    }
    return Icon(
      Icons.account_circle,
      color: Colors.white,
      size: 30,
    );
  }

  CAppBar renderAppBar(BuildContext context, bool hasHero) {
    return CAppBar(
      title: const Text(
        'LQD Photos',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leadings: [
        // default false
        hasBack ?? false
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 30,
                ),
              )
            : Container(),
      ],
      actions: [
        // hasAvatar default true
        hasAvatar ?? true
            ? Obx(
                () => CElevatedButton(
                  width: 30,
                  height: 30,
                  onPressed: () => googleInfo.photoUrl.value != ''
                      ? Get.to(
                          () => UserProfileScreen(),
                        )
                      : _handleSignIn(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                    backgroundColor: primaryBackground,
                  ),
                  child: renderAvatarByLoginInfo(hasHero),
                ),
              )
            : Container(),
      ],
    );
  }
}

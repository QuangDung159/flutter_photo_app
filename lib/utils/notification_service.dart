import 'dart:io';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_photo_app/screens/user_profile_screen.dart';
import 'package:flutter_photo_app/utils/download_util.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService();
  final text = Platform.isIOS;
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  final _localNotifications = FlutterLocalNotificationsPlugin();
  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_logo');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation(
        await FlutterNativeTimezone.getLocalTimezone(),
      ),
    );

    await _localNotifications.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails({String? imageUrl}) async {
    final bigPicture = await DownloadUtil.downloadAndSaveFile(
        imageUrl != null && imageUrl != ''
            ? imageUrl
            : 'https://lh3.googleusercontent.com/3i3ZbEBIj1SE7KEstNzBcmryg3KmLNzseBtqK1EJfXmnjKRfyu-JzbE3Ga61XD6x68LNzy4QeJkW7s6wZQtnNquFoTm6yE2ZD-HZoi1alZq823rqua48jYVg_jjrXdIDuNSyfMVsrdY1oCdobxBimiw7VguSKm1NlK0bcamvItyjomPY_iBUnaFTvbGnPqJZhA18K-4DdW_Z-kp7FYH6BrDlR2qk5dR_tMied3M3qRkTistC90J-Nb-aVatA9qf62iKgNXyN78y_UrgHS8uExbrugv7leXfYVnYqCbKpzqcrv82Sn_YUB92GNQhcYF2CQETMONFrUKK2E5me1vyRGar-QdlGSC7oEAJZ6isSduxhS5KjGEnZ7LMiVjppBwF4kS8vgmjdKdj798jvnTwt7tF3ql8dBa-TAZuBZSExsMVSI3iAY036rK7DraO1ez1bKAP19nWObH07MFwPklRpU8ycqBU4KL3tDVpH6JB-RKMDmDGEKmVwzw_5gt_xYzkVp0bf27XxTTZyL6xWqum3bueKm2ymgBdOnfFo-imw0mfHt5GAEpPo1sqPHi-YZgo7Y_Qv77YtttOdEaeR5qyWv9ACtAohWdXIA_s72ODD1QK_WReiVjXhjL0DLY-D260nIAekRq2FHzztU-wwCKQJbq7M4l0Qupgp_1KndnV9lL1slqfHpsgsnREDSh1_=w2044-h1532-no',
        Platform.isIOS ? 'drinkwater.jpg' : 'drinkwater');

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      groupKey: 'com.lqd.flutter_photo_app',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      largeIcon: FilePathAndroidBitmap(bigPicture),
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicture),
        hideExpandedLargeIcon: false,
      ),
      color: const Color(0xff2196f3),
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
        threadIdentifier: "thread1",
        attachments: <IOSNotificationAttachment>[
          IOSNotificationAttachment(bigPicture)
        ]);

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      behaviorSubject.add(details.payload ?? '');
    }

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<NotificationDetails> _groupedNotificationDetails() async {
    const List<String> lines = <String>[
      'group 1 First drink',
      'group 1   Second drink',
      'group 1   Third drink',
      'group 2 First drink',
      'group 2   Second drink'
    ];
    const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        contentTitle: '5 messages',
        summaryText: 'missed drinks');
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'channel id',
      'channel name',
      groupKey: 'com.lqd.flutter_photo_app',
      channelDescription: 'channel description',
      setAsGroupSummary: true,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      styleInformation: inboxStyleInformation,
      color: Color(0xff2196f3),
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(threadIdentifier: "thread2");

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      behaviorSubject.add(details.payload ?? '');
    }

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<void> showScheduledLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int seconds,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      platformChannelSpecifics,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showPeriodicLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showGroupedNotifications({
    required String title,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    final groupedPlatformChannelSpecifics = await _groupedNotificationDetails();
    await _localNotifications.show(
      0,
      "group 1",
      "First drink",
      platformChannelSpecifics,
    );
    await _localNotifications.show(
      1,
      "group 1",
      "Second drink",
      platformChannelSpecifics,
    );
    await _localNotifications.show(
      3,
      "group 1",
      "Third drink",
      platformChannelSpecifics,
    );
    await _localNotifications.show(
      4,
      "group 2",
      "First drink",
      Platform.isIOS
          ? groupedPlatformChannelSpecifics
          : platformChannelSpecifics,
    );
    await _localNotifications.show(
      5,
      "group 2",
      "Second drink",
      Platform.isIOS
          ? groupedPlatformChannelSpecifics
          : platformChannelSpecifics,
    );
    await _localNotifications.show(
      6,
      Platform.isIOS ? "group 2" : "Attention",
      Platform.isIOS ? "Third drink" : "5 missed drinks",
      groupedPlatformChannelSpecifics,
    );
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    print('id $id');
  }

  void selectNotification(String? payload) {
    if (payload == 'user_profile_screen') {
      Get.to(() => UserProfileScreen());
    }
  }

  void cancelAllNotifications() => _localNotifications.cancelAll();
}
